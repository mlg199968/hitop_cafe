
import 'package:flutter/foundation.dart';

import 'package:hitop_cafe/constants/global.dart';
import 'package:printing/printing.dart';


//
class PrinterProvider extends ChangeNotifier {
  String? _printerName = Global.storageService.getDefaultPrinter();
  Printer? _printer;
  Uint8List? _file;

  String? get getPrinterName => _printerName;
  Printer? get getPrinter => _printer;
  Uint8List? get getFile => _file;

  void setPrinterName(String? printer) {
    // update the printer
    _printerName = printer;
    debugPrint(_printerName.toString());
    // notify the listeners
    notifyListeners();
  }

  void setPrinter(Printer? printer) {
    // update the printer
    _printer = printer;
    debugPrint(_printer.toString());
    // notify the listeners
    notifyListeners();
  }

  void setFilePrint(Uint8List? filePrint) {
    // update the printer
    _file = filePrint;
    debugPrint(_file.toString());
    // notify the listeners
    notifyListeners();
  }
}
