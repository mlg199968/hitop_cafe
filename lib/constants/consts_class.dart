
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
  static const card="card";
  static const cardPersian="به کارت";
  static const other="other";
  static const otherPersian="متفرقه";

  String persianToEnglish(String persian){
    switch(persian){
      case cashPersian:
        return cash;
      case atmPersian:
        return atm;
      case discountPersian:
        return discount;
      case cardPersian:
        return card;
      case otherPersian:
        return other;
    }
    return "";
  }
}

///user types
class UserType{
  static const admin="admin";
  static const adminPersian="ادمین";
  static const manager="manager";
  static const managerPersian="مدیر";
  static const accountant="accountant";
  static const accountantPersian="حسابدار";
  static const waiter="waiter";
  static const waiterPersian="سفارشگیر";
  static const customer="customer";
  static const customerPersian="مشتری";
  static const seller ="seller";
  static const sellerPersian="فروشنده";

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
      case customerPersian:
        return customer;
      case sellerPersian:
        return seller;
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
      case customer:
        return customerPersian;
      case seller:
        return sellerPersian;
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

  ///data base directory directory
  static Future<String> hiveDirectory()async{
    final Directory directory = await getApplicationDocumentsDirectory();
    final newDirectory = Directory("${directory.path}/hitop_cafe/db");
    if (!await newDirectory.exists()) {
      newDirectory.create(recursive: true);
    }
    return newDirectory.path;
  }
  ///data base directory directory
  static Future<String> appDirectory()async{
    final Directory directory = await getApplicationDocumentsDirectory();
    final newDirectory = Directory("${directory.path}/hitop_cafe");
    if (!await newDirectory.exists()) {
      newDirectory.create(recursive: true);
    }
    return newDirectory.path;
  }
  ///items image directory
  static Future<String> itemsImage()async{
    final Directory directory = await getApplicationDocumentsDirectory();
    final newDirectory = Directory("${directory.path}/hitop_cafe/items/images");
    if (!await newDirectory.exists()) {
      newDirectory.create(recursive: true);
    }
    return newDirectory.path;
  }
  ///items  directory
  static Future<String> itemsDirectory()async{
    final Directory directory = await getApplicationDocumentsDirectory();
    Directory newDirectory = Directory("${directory.path}/hitop_cafe/items");
    if (!await newDirectory.exists()) {
      newDirectory.create(recursive: true);
    }
    return newDirectory.path;
  }
  ///customer image directory
  static Future<String> customersImage()async{
    final Directory directory = await getApplicationDocumentsDirectory();
    final newDirectory = Directory("${directory.path}/hitop_cafe/customers/images");
    if (!await newDirectory.exists()) {
      newDirectory.create(recursive: true);
    }
    return newDirectory.path;
  }
  ///customer directory
  static Future<String> customersDirectory() async{
    final Directory directory = await getApplicationDocumentsDirectory();
    final newDirectory = Directory("${directory.path}/hitop_cafe/customers");
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