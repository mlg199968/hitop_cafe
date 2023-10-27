import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier{

  int userLevel=0;
  //ceil count is for how many item you can add to list
  int ceilCount=50;
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


  // void getData(ShopHive shop){
  //   shopName=shop.shopName;
  //   address=shop.address;
  //   phoneNumber=shop.phoneNumber;
  //   phoneNumber2=shop.phoneNumber2;
  //   description=shop.description;
  //   logoImage=shop.logoImage;
  //   signatureImage=shop.signatureImage;
  //   stampImage=shop.stampImage;
  //   shopCode=shop.shopCode;
  //   currency=shop.currency;
  //   preDiscount=shop.preDiscount ;
  //   preBillNumber=shop.preBillNumber;
  //
  // }

  void setUserLevel(int input) async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setInt("level",input);
    userLevel=input;
    if(userLevel==1) {
      ceilCount=1000;
    }
    notifyListeners();
  }

  void getUserLevel() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    int? subsInfo= prefs.getInt("level");

    if(subsInfo!=null){
      userLevel=subsInfo;
      if(userLevel==1) {
        ceilCount=1000;
      }
    }else{
    }
    notifyListeners();
  }

}