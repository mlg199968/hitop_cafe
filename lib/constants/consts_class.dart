
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
///payment methods
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

///payment methods
class UserType{
  static const admin="admin";
  static const adminPersian="ادمین";
  static const manager="manager";
  static const managerPersian="مدیر";
  static const accountant="accountant";
  static const accountantPersian="حسابدار";
  static const waiter="waiter";
  static const waiterPersian="سفارشگیر";

  String persianToEnglish(String persian){
    switch(persian){
      case managerPersian:
        return manager;
      case accountantPersian:
        return accountant;
      case waiterPersian:
        return waiter;
      case adminPersian:
        return admin;
    }
    return "";
  }
 String englishToPersian(String english){
    switch(english){
      case manager:
        return managerPersian;
      case accountant:
        return accountantPersian;
      case waiter:
        return waiterPersian;
      case admin:
        return adminPersian;
    }
    return "";
  }
  //get values list
  List getList(){
   return [managerPersian,accountantPersian,waiterPersian];


  }
}
///documents directory to save and get data
class Address{

  //data base directory directory
  static Future<String> hiveDirectory()async{
    final Directory directory = await getApplicationDocumentsDirectory();
    final newDirectory = Directory("${directory.path}/hitop_cafe/db");
    if (!await newDirectory.exists()) {
      newDirectory.create(recursive: true);
    }
    return newDirectory.path;
  }
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
    Directory newDirectory = Directory("${directory.path}/hitop_cafe/items");
    if (!await newDirectory.exists()) {
      newDirectory.create(recursive: true);
    }
    return newDirectory.path;
  }

  //image user profile  directory
  static Future<String> profileDirectory()async{
    final Directory directory = await getApplicationDocumentsDirectory();
    Directory newDirectory = Directory("${directory.path}/hitop_cafe/users/profiles");
    if (!await newDirectory.exists()) {
      newDirectory.create(recursive: true);
    }
    return newDirectory.path;
  }


}

///scroll option
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}