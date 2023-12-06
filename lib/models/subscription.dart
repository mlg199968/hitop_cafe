
import 'dart:convert';
import 'package:hive/hive.dart';

part 'subscription.g.dart';
@HiveType(typeId: 8)
class Subscription extends HiveObject{

  @HiveField(0)
  late String name;
  @HiveField(1)
  late String phoneNumber;
  @HiveField(2)
  String? email;
  @HiveField(3)
  late int level;
  @HiveField(4)
  DateTime? startDate;
  @HiveField(5)
  DateTime? endDate;
  @HiveField(6)
  double? payAmount;
  @HiveField(7)
  String? authority;
  @HiveField(8)
  String? status;
  @HiveField(9)
  String? refId;
  @HiveField(10)
  String? deviceId;
  @HiveField(11)
  String description="";
  @HiveField(12)
  int? id;




  Map<String, dynamic> toMap() {
    return {
      'name': name ,
      'phone': phoneNumber,
      'email': email ?? "",
      'level': level.toString(),
      'startDate': startDate?.toIso8601String() ?? "",
      'endDate': endDate?.toIso8601String() ?? "",
      'payAmount': payAmount.toString(),
      'Authority': authority ?? "",
      'Status': status ?? "",
      'refId': refId  ?? "",
      'deviceId': deviceId ?? "",
      'description': description ,
     'user_id': id?.toString() ?? "",
    };
  }

  Subscription fromMap(Map<String, dynamic> map) {
     Subscription subscription=Subscription()
      ..name= map['name'] ?? ""
      ..phoneNumber= map['phone'] ?? ""
      ..email= map['email'] ?? ""
      ..level= int.parse(map['level'] ?? 0)
      ..startDate= map['startDate']==null?DateTime.now():DateTime.parse(map['startDate'])
      ..endDate= map['endDate']==null?null:DateTime.parse(map['endDate'])
      ..payAmount= map['payAmount'] ?? 0
      ..authority= map['Authority']
      ..status= map['Status']
      ..refId= map['refId']
      ..deviceId= map['deviceId']
      ..description= map['description']
      ..id= int.parse(map['user_id']);
     return subscription;
  }

  String toJson() => jsonEncode(toMap());

  Subscription fromJson(String source) => fromMap(
    jsonDecode(source),
  );
}

//run this code for create adaptor:
//flutter packages pub run build_runner build --delete-conflicting-outputs