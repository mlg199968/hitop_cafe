
import 'package:flutter/foundation.dart';

import 'package:hitop_cafe/constants/global.dart';
import 'package:printing/printing.dart';


//
class PrinterProvider extends ChangeNotifier {
  String? _printerName = Global.storageService.getdefaultPrinter();
  Printer? _printer;

  // PrinterProvider({Printer? printer}) {
  //   _printer = printer;
  // }

  String? get getPrinterName => _printerName;
  Printer? get getPrinter => _printer;

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
}
