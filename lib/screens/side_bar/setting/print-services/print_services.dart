import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_simple_bluetooth_printer/flutter_simple_bluetooth_printer.dart';

import 'package:flutter/services.dart';
import 'package:hitop_cafe/constants/error_handler.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:image/image.dart' as img;
import 'package:pdfx/pdfx.dart' as pdfx;
import 'package:printing/printing.dart' as printing;
import 'package:provider/provider.dart';
import 'package:thermal_printer/esc_pos_utils_platform/esc_pos_utils_platform.dart';
import 'package:thermal_printer/thermal_printer.dart';

class PrintServices {
  ///printer priority for print
  printPriority(BuildContext context, {required Uint8List unit8File}) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    if (Platform.isWindows) {
      await windowsDirectPrint(
        userProvider.selectedPrinter,
        unit8File,
      );
    } else if (Platform.isAndroid || Platform.isIOS) {
      await escPosPrint(context, unit8File, ip: userProvider.printerIp);
    }
  }

  static List devices = [];
  _scan(PrinterType type, {bool isBle = false}) {
    // Find printers
    PrinterManager.instance
        .discovery(type: type, isBle: isBle)
        .listen((device) {
      devices.add(device);
    });
  }

  _connectDevice(PrinterDevice selectedPrinter, PrinterType type,
      {bool reconnect = false, bool isBle = false, String? ipAddress}) async {
    switch (type) {
      // only windows and android
      case PrinterType.usb:
        await PrinterManager.instance.connect(
            type: type,
            model: UsbPrinterInput(
                name: selectedPrinter.name,
                productId: selectedPrinter.productId,
                vendorId: selectedPrinter.vendorId));
        break;
      // only iOS and android
      case PrinterType.bluetooth:
        await PrinterManager.instance.connect(
            type: type,
            model: BluetoothPrinterInput(
                name: selectedPrinter.name,
                address: selectedPrinter.address!,
                isBle: isBle,
                autoConnect: reconnect));
        break;
      case PrinterType.network:
        await PrinterManager.instance.connect(
            type: type,
            model: TcpPrinterInput(
                ipAddress: ipAddress ?? selectedPrinter.address!));
        break;
      default:
    }
  }

  _sendBytesToPrint(List<int> bytes, PrinterType type) async {
    PrinterManager.instance.send(type: type, bytes: bytes);
  }

  disconnectDevice(PrinterType type) async {
    await PrinterManager.instance.disconnect(type: type);
  }
///escPos printer
  Future<void> escPosPrint(context,Uint8List unit8File,{PaperSize paperSize=PaperSize.mm80,required String ip}) async {
    try {

      //at first we convert unit8file to Image then we give it to the printer
      final document = await pdfx.PdfDocument.openData(unit8File);
      final page = await document.getPage(1);
      final pageImage = await page.render(width: page.width*10, height: page.height*10);
      await page.close();

      List<int> bytes = [];
      final profile = await CapabilityProfile.load();
      final generator = Generator(paperSize, profile);
      //
      img.Image? image = img.decodeImage(pageImage!.bytes);
      image = img.copyResize(image!, width: 500);
      bytes += generator.image(image);
      bytes += generator.feed(2);
      bytes += generator.cut();
      // _scan(PrinterType.network);
      await PrinterManager.instance.connect(
          type: PrinterType.network, model: TcpPrinterInput(ipAddress: ip));
      await _sendBytesToPrint(bytes, PrinterType.network);

      await PrinterManager.instance.disconnect(type: PrinterType.network);
    } catch (e) {
      ErrorHandler.errorManger(
        context,
        e,
        title: "print Services-escPosPrint function error",
      );
    }
  }

  ///direct printing windows
  Future<void> windowsDirectPrint(
      printing.Printer? printer, Uint8List unit8File) async {
    if (printer != null && Platform.isWindows) {
      await printing.Printing.directPrintPdf(
          usePrinterSettings: true,
          printer: printer,
          onLayout: (_) => unit8File);
      // await Printing.layoutPdf(
      //     onLayout: (_) => file);
    }
  }

  ///scan the bluetooth devices from simpleBluetoothPrinter package
  static Future<void> scanSimpleBluetoothDevices(bool isOnBT,
      {required Function(List<BluetoothDevice>? btList, bool? isScaning)
          onChange}) async {
    final bluetoothManager = FlutterSimpleBluetoothPrinter.instance;
    List<BluetoothDevice> devices = [];
    devices.clear();
    try {
      if (isOnBT) {
        final results =
            await bluetoothManager.scan(timeout: const Duration(seconds: 10));
        devices.addAll(results);
        onChange(devices, false);
      } else {
        final bondedDevices = await bluetoothManager.getAndroidPairedDevices();
        devices.addAll(bondedDevices);
        onChange(devices, false);
      }
    } on BTException catch (e) {
      debugPrint(e.toString());
    } finally {
      onChange(null, false);
    }
  }
}
