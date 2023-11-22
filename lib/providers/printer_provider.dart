
import 'package:flutter/foundation.dart';

import 'package:hitop_cafe/constants/global.dart';
import 'package:printing/printing.dart';


//
class PrinterProvider extends ChangeNotifier {
  Printer? _printer;
  Uint8List? _file;


  Uint8List? get getFile => _file;




  void setFilePrint(Uint8List? filePrint) {
    // update the printer
    _file = filePrint;
    debugPrint(_file.toString());
    // notify the listeners
    notifyListeners();
  }
}
