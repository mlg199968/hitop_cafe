

import 'package:hitop_cafe/models/raw_ware.dart';

class WareTools {

  ///create new Ware form Raw Ware (to prevent from interfere)
  static RawWare copyToNewWare(RawWare ware){
    RawWare newWare=RawWare.fromMap(ware.toMap());
    return newWare;
  }

  /// search and sort the ware List
  static List<RawWare> filterList(
      List<RawWare> list, String? keyWord, String sort) {

    if (keyWord != null && keyWord != "") {
      list = list.where((element) {
        String wareName = element.wareName.toLowerCase().replaceAll(" ", "");
        //String serial=element.serialNumber.toLowerCase().replaceAll(" ", "");
        String key = keyWord.toLowerCase().replaceAll(" ", "");
        if (wareName.contains(key)) {
          return true;
        } else {
          return false;
        }
      }).toList();
    }


    switch (sort) {

      case "حروف الفبا":
        list.sort((a, b) {

          return a.wareName.compareTo(b.wareName);
        });
        break;
      case "موجودی کالا":
        list.sort((b, a) {
          return a.quantity.compareTo(b.quantity);
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
