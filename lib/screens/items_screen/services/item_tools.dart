

import 'dart:io';
import 'package:hitop_cafe/constants/consts_class.dart';
import 'package:hitop_cafe/models/item.dart';



class ItemTools {

  static saveImage(String? path,String idName)async{
    if(path!=null){
      //get image directory from consts_class file in constants folder
      final String directory = await Address.itemsImage();

      File newFile= await File(path).copy("$directory/$idName.jpg");
      //delete file picker cache file in android and ios because windows show orginal path file so when you delete it's delete orginal file
      if(Platform.isAndroid || Platform.isIOS) {
        await File(path).delete();
      }
      return newFile.path;

    }
    return null;
  }

  /// search and sort the ware List
  static List<Item> filterList(
      List<Item> list, String? keyWord, String sort) {

    if (keyWord != null && keyWord != "") {
      list = list.where((element) {
        String itemName = element.itemName.toLowerCase().replaceAll(" ", "");
        //String serial=element.serialNumber.toLowerCase().replaceAll(" ", "");
        String key = keyWord.toLowerCase().replaceAll(" ", "");
        if (itemName.contains(key)) {
          return true;
        } else {
          return false;
        }
      }).toList();
    }


    switch (sort) {

      case "حروف الفبا":
        list.sort((a, b) {

          return a.itemName.compareTo(b.itemName);
        });
        break;

      case "تاریخ ثبت":
        list.sort((b, a) {
          return a.createDate.compareTo(b.createDate);
        });
        break;
      case 'تاریخ ویرایش':
        list.sort((b, a) {
          return a.modifiedDate.compareTo(b.modifiedDate);
        });
        break;
    }
    return list;
  }
///create new item form item (to prevent from interfere)
  static Item copyToNewItem(Item i){
    Item newItem=Item().fromMap(i.toMap());
    return newItem;
  }
}
