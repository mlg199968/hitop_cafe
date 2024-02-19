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
  ///printers
  @HiveField(12)
  Map? printer;
  @HiveField(13)
  Map? printer2;
  @HiveField(14)
  String? printerIp="192.168.1.1";
  @HiveField(15)
  String? printerIp2;
  @HiveField(16)
  String? printTemplate;
  @HiveField(17)
  String? printTemplate2;
  ///
  @HiveField(18)
  String? fontFamily;
  @HiveField(19)
  User? activeUser;
  @HiveField(20)
  String? appType;
  @HiveField(21)
  int? userLevel=0;
  @HiveField(22)
  int? port;
  @HiveField(23)
  String? ipAddress;
  @HiveField(24)
  String? subnet;


}



//run this code for create adaptor:
//flutter packages pub run build_runner build --delete-conflicting-outputs
//dart run build_runner build --delete-conflicting-outputs