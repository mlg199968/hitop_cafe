import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:hitop_cafe/constants/error_handler.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
// import 'package:pdfx/pdfx.dart' as pdfx;
import 'package:printing/printing.dart' as printing;
import 'package:provider/provider.dart';
// import 'package:thermal_printer/thermal_printer.dart';

class PrintServices {
  const PrintServices(
    this.context, {
    required this.unit8File,
    this.printerNumber = 1,
  });
  final BuildContext context;
  final Uint8List unit8File;
  final int printerNumber;
  printing.Printer? get selectedPrinter {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    if (printerNumber == 1) {
      return userProvider.selectedPrinter;
    } else {
      return userProvider.selectedPrinter2;
    }
  }

  String get printerIp {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    if (printerNumber == 1) {
      return userProvider.printerIp;
    } else {
      return userProvider.printerIp2;
    }
  }

  ///printer priority for print
  printPriority() async {
    if (Platform.isWindows) {
      await windowsDirectPrint(
        selectedPrinter,
        unit8File,
      );
    } else if (Platform.isAndroid || Platform.isIOS) {
      await escPosPrint(ip: printerIp);
    }
  }


  ///escPos printer
  Future<void> escPosPrint(
      {PaperSize paperSize = PaperSize.mm80, required String ip}) async {
    try {
      // //at first we convert unit8file to Image then we give it to the printer
      // final document = await pdfx.PdfDocument.openData(unit8File);
      // final page = await document.getPage(1);
      // final pageImage =
      //     await page.render(width: page.width * 10, height: page.height * 10);
      // await page.close();
      //
      // List<int> bytes = [];
      // final profile = await CapabilityProfile.load();
      // final generator = Generator(paperSize, profile);
      // //
      // img.Image? image = img.decodeImage(pageImage!.bytes);
      // image = img.copyResize(image!, width: 500);
      // bytes += generator.image(image);
      // bytes += generator.feed(2);
      // bytes += generator.cut();
      // _scan(PrinterType.network);
      //await PrinterManager.instance.connect(type: PrinterType.network, model: TcpPrinterInput(ipAddress: ip));
      // await PrinterManager.instance.tcpPrinterConnector
      //     .connect(TcpPrinterInput(ipAddress: ip))
      //     .catchError((error, stackTrace) => ErrorHandler.errorManger(
      //         context, error,
      //         route: stackTrace.toString(),
      //         title: "connect to printer ip address error",
      //         showSnackbar: true));
      // await PrinterManager.instance
      //     .send(type: PrinterType.network, bytes: bytes);
      // await PrinterManager.instance.tcpPrinterConnector.disconnect();
    } catch (e) {
      ErrorHandler.errorManger(
        null,
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





  ///
  // static List devices = [];
  // _scan(PrinterType type, {bool isBle = false}) {
  //   // Find printers
  //   PrinterManager.instance
  //       .discovery(type: type, isBle: isBle)
  //       .listen((device) {
  //     devices.add(device);
  //   });
  // }
  // ///
  // _connectDevice(PrinterDevice selectedPrinter, PrinterType type,
  //     {bool reconnect = false, bool isBle = false, String? ipAddress}) async {
  //   switch (type) {
  //   // only windows and android
  //     case PrinterType.usb:
  //       await PrinterManager.instance.connect(
  //           type: type,
  //           model: UsbPrinterInput(
  //               name: selectedPrinter.name,
  //               productId: selectedPrinter.productId,
  //               vendorId: selectedPrinter.vendorId));
  //       break;
  //   // only iOS and android
  //     case PrinterType.bluetooth:
  //       await PrinterManager.instance.connect(
  //           type: type,
  //           model: BluetoothPrinterInput(
  //               name: selectedPrinter.name,
  //               address: selectedPrinter.address!,
  //               isBle: isBle,
  //               autoConnect: reconnect));
  //       break;
  //     case PrinterType.network:
  //       await PrinterManager.instance.connect(
  //           type: type,
  //           model: TcpPrinterInput(
  //               ipAddress: ipAddress ?? selectedPrinter.address!));
  //       break;
  //     default:
  //   }
  // }


}
