

import 'package:hitop_cafe/models/item.dart';



class ItemTools {

  /// search and sort the ware List
  static List<Item> filterList(
      List<Item> list, String? keyWord, String sort,String category) {
    list=list.where((ware) => category ==
        ware.category ||
        category == "همه").toList() ;
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

  ///just for debug
  static List<Item> createFakeItems() {
    return List.generate(
        1000000,
            (index) => Item()
          ..itemName = "item number $index"
          ..category = "fake item"
          ..unit="عدد"
          ..createDate=DateTime.now()
          ..quantity = index * 2);
  }
}
