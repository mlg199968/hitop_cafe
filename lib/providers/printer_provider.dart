
import 'package:flutter/foundation.dart';

//
class PrinterProvider extends ChangeNotifier {
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
