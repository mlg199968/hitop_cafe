import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/models/shop.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier{

  int userLevel=1;
  //ceil count is for how many item you can add to list
  int _ceilCount=3;
  String ceilCountMessage="این نسخه از برنامه دارای محدودیت حداکثر ده آیتم است ";
  //*****
  String shopName="نام فروشگاه";
  String address="آدرس فروشگاه";
  String phoneNumber="شماره تلفن اول";
  String phoneNumber2="شماره تلفن دوم";
  String description="توضیحات";
  String? logoImage;
  String? signatureImage;
  String? stampImage;
  String shopCode="";
  String currency="تومان";
  double preDiscount=0;
  int preBillNumber=1;
  String fontFamily=kFonts[0];
  Printer? _selectedPrinter;
  String printerIp="192.168.1.1";

  int get ceilCount =>_ceilCount;
  Printer? get selectedPrinter=>_selectedPrinter ?? getDefaultPrinter();

  void getData(Shop shop){
    shopName=shop.shopName;
    address=shop.address;
    phoneNumber=shop.phoneNumber;
    phoneNumber2=shop.phoneNumber2;
    description=shop.description;
    logoImage=shop.logoImage;
    signatureImage=shop.signatureImage;
    stampImage=shop.stampImage;
    shopCode=shop.shopCode;
    currency=shop.currency;
    preDiscount=shop.preTax ;
    preBillNumber=shop.preBillNumber;
    _selectedPrinter=shop.printer==null?null:Printer.fromMap(shop.printer!);
    printerIp=shop.printerIp ?? "192.168.1.1" ;

  }

  void setUserLevel(int input) async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setInt("level",input);
    userLevel=input;
    if(userLevel==1) {
      _ceilCount=1000;
    }
    notifyListeners();
  }

  void getUserLevel() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    int? subsInfo= prefs.getInt("level");

    if(subsInfo!=null){
      userLevel=subsInfo;
      if(userLevel==1) {
        _ceilCount=1000;
      }
    }else{
    }
    notifyListeners();
  }


  Printer? getDefaultPrinter() {
    if(Platform.isWindows) {
      Printing.listPrinters().then((printers) {
// Find the printer that has isDefault: true
      Printer defaultPrinter = printers.firstWhere((p) => p.isDefault);
      return defaultPrinter;
    });
    }
    return null;
  }

  getFontFamily(String font){
    fontFamily=font;
    notifyListeners();
  }
}