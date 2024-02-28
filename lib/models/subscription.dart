
import 'dart:convert';
import 'package:hive/hive.dart';

import 'server_models/device.dart';

part 'subscription.g.dart';
@HiveType(typeId: 8)
class Subscription extends HiveObject{

  @HiveField(0)
  String? name;
  @HiveField(1)
  late String phone;
  @HiveField(2)
  String? email;
  @HiveField(3)
  late int level;
  @HiveField(4)
  DateTime? startDate;
  @HiveField(5)
  DateTime? endDate;
  @HiveField(6)
  int? amount;
  @HiveField(7)
  String? authority;
  @HiveField(8)
  String? status;
  @HiveField(9)
  String? refId;
  @HiveField(10)
  Device? device;
  @HiveField(11)
  String? description;
  @HiveField(12)
  int? id;
  @HiveField(13)
  String? platform;




  Map<String, dynamic> toMap() {
    return {
      'name': name ,
      'phone': phone,
      'email': email,
      'level': level,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'amount': amount,
      'Authority': authority,
      'Status': status,
      'refId': refId,
      'deviceId': device?.toMap(),
      'description': description ,
     'user_id': id,
     'platform': platform,
    };
  }

  Subscription fromMap(Map<String, dynamic> map) {

     Subscription subscription=Subscription()
      ..name= map['name'] ?? ""
      ..phone= map['phone'] ?? ""
      ..email= map['email'] ?? ""
      ..level= map['level'] ?? 0
      ..startDate= DateTime.tryParse(map['startDate'])
      ..endDate= DateTime.tryParse(map['endDate'])
      ..amount= map['amount'] ?? 0
      ..authority= map['Authority']
      ..status= map['Status']
      ..refId= map['refId']
      ..device=map['deviceId']!=null? Device.fromMap(map['device']):null
      ..description= map['description']
      ..id= int.tryParse(map['user_id']);
    print("from map***************");
     return subscription;
  }

  String toJson() => jsonEncode(toMap());

  Subscription fromJson(String source) => fromMap(
    jsonDecode(source),
  );
}

//run this code for create adaptor:
//flutter packages pub run build_runner build --delete-conflicting-outputs