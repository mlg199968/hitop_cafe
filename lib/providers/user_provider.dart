import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/server_models/device.dart';
import 'package:hitop_cafe/models/shop.dart';
import 'package:hitop_cafe/models/subscription.dart';
import 'package:hitop_cafe/models/user.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:printing/printing.dart';

class UserProvider extends ChangeNotifier {
  int _userLevel = 0;
  int get userLevel =>_subscription!=null?_subscription!.level: _userLevel;
  Subscription? _subscription;
  Subscription? get subscription=>_subscription;
  ///
  Future<bool> get deviceAuthority async{
    Device currentDevice=await getDeviceInfo();
    if(_subscription != null && _subscription!.device?.id==currentDevice.id){
      return true;
    }else{

      _subscription?.level=0;
      _userLevel=0;
      return false;
    }

  }
  //ceil count is for how many item you can add to list
  int get ceilCount => _userLevel == 0 ? 20 : 99999999;
  String ceilCountMessage =
      "این نسخه از برنامه دارای محدودیت حداکثر 20 آیتم است ";
  User? _user;
  User? get activeUser => _user;
  String? _appType;
  String? get appType => _appType;
  String? _backupDirectory;
  String? get backupDirectory=>_backupDirectory;

  bool saveBackupOnExist=false;

  //*****
  Shop sampleShop = Shop()
    ..shopName = "shopName"
    ..address = "address"
    ..phoneNumber = "phoneNumber"
    ..phoneNumber2 = ""
    ..preBillNumber = 1
    ..preTax = 0
    ..currency = "ریال";


  List<Map> descriptionList=[];


  String shopName = "نام فروشگاه";
  String address = "آدرس فروشگاه";
  String phoneNumber = "شماره تلفن اول";
  String phoneNumber2 = "شماره تلفن دوم";
  String description = "توضیحات";
  String? logoImage;
  String? signatureImage;
  String? stampImage;
  String shopCode = "";
  String currency = "تومان";
  double preDiscount = 0;
  int preBillNumber = 1;
  String _fontFamily = kFonts[0];
  String get fontFamily => _fontFamily;
  ///printers declaration
  Printer? _selectedPrinter;
  Printer? get selectedPrinter => _selectedPrinter;
  Printer? _selectedPrinter2;
  Printer? get selectedPrinter2 => _selectedPrinter2;
  String? printTemplate = PrintType.p80mm.value;
  String printerIp = "192.168.1.1";
  String printerIp2 = "192.168.1.2";

  void getData(Shop shop) {
    shopName = shop.shopName;
    address = shop.address;
    phoneNumber = shop.phoneNumber;
    phoneNumber2 = shop.phoneNumber2;
    description = shop.description;
    logoImage = shop.logoImage;
    signatureImage = shop.signatureImage;
    stampImage = shop.stampImage;
    shopCode = shop.shopCode;
    currency = shop.currency;
    preDiscount = shop.preTax;
    preBillNumber = shop.preBillNumber;
    _fontFamily = shop.fontFamily ?? kFonts[0];
    _selectedPrinter =
        shop.printer == null ? null : Printer.fromMap(shop.printer!);
    _selectedPrinter2 =
        shop.printer == null ? null : Printer.fromMap(shop.printer!);
    printTemplate = shop.printTemplate;
    printerIp = shop.printerIp ?? "192.168.1.1";
    printerIp2 = shop.printerIp2 ?? "192.168.1.2";
    _user = shop.activeUser;
    _appType = shop.appType;
    _userLevel = shop.userLevel ?? 0;
    _subscription=shop.subscription;
    if(shop.descriptionList!=null) {
      descriptionList=shop.descriptionList!;
    }
    saveBackupOnExist=shop.saveBackupOnExist ?? false;
    _backupDirectory=shop.backupDirectory;
    ///this for just use complete for debug app
    if (kDebugMode) {
      _userLevel = 0;
    }
  }

  void setUserLevel(int input) async {
    // SharedPreferences prefs= await SharedPreferences.getInstance();
    // prefs.setInt("level",input);
    Shop shop = HiveBoxes.getShopInfo().getAt(0)!;
    shop.userLevel = input;
    HiveBoxes.getShopInfo().putAt(0, shop);
    _userLevel = input;
    notifyListeners();
  }
  ///set subscription
  void setSubscription(Subscription? subs){
    Shop shop = HiveBoxes.getShopInfo().getAt(0)!;
    shop.subscription = subs;
    HiveBoxes.getShopInfo().putAt(0, shop);
    _subscription=subs;
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
    if (Platform.isWindows) {
      Printing.listPrinters().then((printers) {
// Find the printer that has isDefault: true
        Printer defaultPrinter = printers.firstWhere((p) => p.isDefault);
        return defaultPrinter;
      });
    }
    return null;
  }
  ///set backup directory
setBackupDirectory(String? directory){
    _backupDirectory=directory;
    notifyListeners();
}
  ///user functions
  setUser(User? user) {
    _user = user;
    notifyListeners();
    if (_appType == AppType.waiter.value) {
      Shop old = HiveBoxes.getShopInfo().values.single;
      old.activeUser = user;
      HiveBoxes.getShopInfo().putAt(0, old);
    }
  }

  removeUser() {
    _user = null;
    notifyListeners();
  }

  ///appType Functions
  setAppType(AppType? type) {
    _appType = type?.value;
    notifyListeners();
  }

  removeAppType() {
    _appType = null;
    notifyListeners();
  }

  setFontFamily(String font) {
    _fontFamily = font;
    notifyListeners();
  }

  setFontFromHive() {
    Shop? shop = HiveBoxes.getShopInfo().get(0);
    if (shop != null && shop.fontFamily != null) {
      _fontFamily = shop.fontFamily!;
    }
  }
  ///item or order description list actions
  addDescription(Map des){
    descriptionList.add(des);
    notifyListeners();

  }
  removeDescription(Map des){
    descriptionList.remove(des);
    notifyListeners();
    Shop shop=HiveBoxes.getShopInfo().values.single;
    shop.descriptionList=descriptionList;
    HiveBoxes.getShopInfo().putAt(0, shop);
  }
 sortDescription(String? id){
   descriptionList.sort((a,b) {
     if(a["id"]==id) {
       return -1;
     }else{
       return 1;
     }
   });
   // notifyListeners();
  }
}
