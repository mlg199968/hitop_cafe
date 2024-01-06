import 'package:hitop_cafe/models/user.dart';
import 'package:hive/hive.dart';

part 'shop.g.dart';

@HiveType(typeId: 6)
class Shop extends HiveObject {
  @HiveField(0)
  String shopName="نام فروشگاه";
  @HiveField(1)
  String address="آدرس فروشگاه";
  @HiveField(2)
  String phoneNumber="شماره تلفن اول";
  @HiveField(3)
  String phoneNumber2="شماره تلفن دوم";
  @HiveField(4)
  String description="توضیحات";
  @HiveField(5)
  String? logoImage;
  @HiveField(6)
  String? signatureImage;
  @HiveField(7)
  String? stampImage;
  @HiveField(8)
  String shopCode="";
  @HiveField(9)
  String currency="ریال";
  @HiveField(10)
  double preTax=0;
  @HiveField(11)
  int preBillNumber=0;
  @HiveField(12)
  Map? printer;
  @HiveField(13)
  String? fontFamily;
  @HiveField(14)
  String? printerIp="192.168.1.1";
  @HiveField(15)
  User? activeUser;
  @HiveField(16)
  String? appType;
  @HiveField(17)
  int? userLevel=0;

}



//run this code for create adaptor:
//flutter packages pub run build_runner build --delete-conflicting-outputs
//dart run build_runner build --delete-conflicting-outputs