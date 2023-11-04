

import 'dart:io';

import 'package:hitop_cafe/models/item.dart';
import 'package:path_provider/path_provider.dart';


class ItemTools {

  static saveImage(String? path,String idName)async{
    if(path!=null){
      final Directory directory = await getApplicationDocumentsDirectory();
      final newDirectory = Directory("${directory.path}/hitop_cafe/items/images");
      if (!await newDirectory.exists()) {
        newDirectory.create(recursive: true);
      }

      File newFile= await File(path).copy("${newDirectory.path}/$idName.jpg");
      await File(path).delete();
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
}
