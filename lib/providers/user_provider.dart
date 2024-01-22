import 'dart:io';


import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/models/shop.dart';
import 'package:hitop_cafe/models/user.dart';
import 'package:hitop_cafe/screens/side_bar/notice_screen/services/notice_tools.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:printing/printing.dart';


class UserProvider extends ChangeNotifier{

  int _userLevel=0;
  int get userLevel=>_userLevel;

  //ceil count is for how many item you can add to list
  int get ceilCount =>_userLevel==0?10:1000;
  String ceilCountMessage="این نسخه از برنامه دارای محدودیت حداکثر ده آیتم است ";
  User? _user;
  User? get activeUser=>_user;
  String? _appType;
 String? get appType=>_appType;

  //*****
  Shop sampleShop=Shop()..shopName="shopName"..address="address"..phoneNumber="phoneNumber"..phoneNumber2=""..preBillNumber=1..preTax=0..currency="ریال";
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
  Printer? get selectedPrinter=>_selectedPrinter ?? getDefaultPrinter();
  String printerIp="192.168.1.1";




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
    fontFamily=shop.fontFamily ?? kFonts[0];
    _selectedPrinter=shop.printer==null?null:Printer.fromMap(shop.printer!);
    printerIp=shop.printerIp ?? "192.168.1.1" ;
    _user=shop.activeUser;
    _appType=shop.appType;
    _userLevel=shop.userLevel ?? 0;
    ///this for just use complete for debug app
    _userLevel=1;
  }

  void setUserLevel(int input) async{
    // SharedPreferences prefs= await SharedPreferences.getInstance();
    // prefs.setInt("level",input);
    Shop shop=HiveBoxes.getShopInfo().getAt(0)!;
    shop.userLevel=input;
    HiveBoxes.getShopInfo().putAt(0, shop);
    _userLevel=input;
    notifyListeners();
  }

  // void getUserLevel() async{
  //   SharedPreferences prefs= await SharedPreferences.getInstance();
  //   int? subsInfo= prefs.getInt("level");
  //
  //   if(subsInfo!=null){
  //     _userLevel=subsInfo;
  //     if(_userLevel==1) {
  //       _ceilCount=1000;
  //     }
  //   }else{
  //   }
  //
  //   notifyListeners();
  // }


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
  ///user functions
setUser(User? user){
    _user=user;
    notifyListeners();
    if(_appType==AppType.waiter.value){
      Shop old=HiveBoxes.getShopInfo().values.single;
      old.activeUser=user;
      HiveBoxes.getShopInfo().putAt(0, old);
    }
}
removeUser(){
    _user=null;
    notifyListeners();
}
///appType Functions
setAppType(AppType? type){
    _appType=type?.value;
    notifyListeners();
}
removeAppType(){
    _appType=null;
    notifyListeners();
}
  getFontFamily(String font){
    fontFamily=font;
    notifyListeners();
  }
  // loadNotification(context) async {
  //   if(context.mounted) {
  //     await NoticeTools.readNotifications(context,timeout: 5);
  //   }
  // }
}