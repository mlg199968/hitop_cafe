
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class PayMethod{
  static const cash="cash";
  static const cashPersian="نقدی";
  static const atm="atm";
  static const atmPersian="کارتخوان";
  static const discount="discount";
  static const discountPersian="تخفیف";

  String persianToEnglish(String persian){
    switch(persian){
      case cashPersian:
        return cash;
      case atmPersian:
        return atm;
      case discountPersian:
        return discount;
    }
    return "";
  }
}




///documents directory to save and get data
class Address{
  //items image directory
  static Future<String> itemsImage()async{
    final Directory directory = await getApplicationDocumentsDirectory();
    final newDirectory = Directory("${directory.path}/hitop_cafe/items/images");
    if (!await newDirectory.exists()) {
      newDirectory.create(recursive: true);
    }
    return newDirectory.path;
  }
  //items  directory
  static Future<String> itemsDirectory()async{
    final Directory directory = await getApplicationDocumentsDirectory();
    final newDirectory = Directory("${directory.path}/hitop_cafe/items");
    if (!await newDirectory.exists()) {
      newDirectory.create(recursive: true);
    }
    return newDirectory.path;
  }


}