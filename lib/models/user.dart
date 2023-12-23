import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 11)
class User extends HiveObject {
  @HiveField(0)
  late String name;
  @HiveField(1)
  String? userName;
  @HiveField(2)
  late String password;
  @HiveField(3)
  List accessList = [];
  @HiveField(4)
  late String userType;
  @HiveField(5)
  String? image;
  @HiveField(6)
  String? socialCode;
  @HiveField(7)
  String? email;
  @HiveField(8)
  String? phone;
  @HiveField(9)
  String? description;
  @HiveField(10)
  double? score;
  @HiveField(11)
  late DateTime createDate;
  @HiveField(12)
  DateTime modifiedDate = DateTime.now();
  @HiveField(13)
  late String userId;
}

//run this code for create adaptor:
//flutter packages pub run build_runner build --delete-conflicting-outputs
