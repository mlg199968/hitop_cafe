import 'dart:convert';

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
  @HiveField(14)
  String? userDevice;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'userName': userName,
      'password': password,
      'accessList': accessList,
      'userType': userType,
      'image': image,
      'socialCode': socialCode,
      'email': email,
      'phone': phone,
      'description': description,
      'score': score,
      'createDate': createDate.toIso8601String(),
      'modifiedDate': modifiedDate.toIso8601String(),
      'userId': userId ,
      'userDevice': userDevice,
    };
  }

   User fromMap(Map<String, dynamic> map) {
    User user= User()
      ..name= map['name'] ?? ""
      ..userName= map['userName']
      ..password= map['password'] ?? ""
      ..accessList= map['accessList']
      ..userType= map['userType'] ?? ""
      ..image= map['image']
      ..socialCode= map['socialCode']
      ..email= map['email']
      ..phone= map['phone']
      ..description= map['description']
      ..score= map['score']
      ..createDate= DateTime.parse(map['createDate'])
      ..modifiedDate= DateTime.parse(map['modifiedDate'])
      ..userId= map['userId'] ?? "0"
      ..userDevice= map['userDevice'];
    return user;
  }

String toJson()=>jsonEncode(toMap());
  User fromJson(String source)=>fromMap(jsonDecode(source));
}

//run this code for create adaptor:
//flutter packages pub run build_runner build --delete-conflicting-outputs
//dart run build_runner build --delete-conflicting-outputs
