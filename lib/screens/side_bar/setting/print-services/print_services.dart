import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_simple_bluetooth_printer/flutter_simple_bluetooth_printer.dart';


import 'package:flutter/services.dart';

class PrintServices {

  printPriority(BuildContext context,{required Uint8List unit8File}){

  }


///escPos printer
  void escPosPrint(Uint8List unit8File,{PaperSize paperSize=PaperSize.mm80}) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(paperSize, profile);
    List<int> bytes = [];
    generator.rawBytes(unit8File.buffer.asInt8List());
    generator.feed(2);
    generator.cut();
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
