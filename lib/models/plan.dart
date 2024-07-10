


import 'dart:convert';

import 'package:hive/hive.dart';
part 'plan.g.dart';
@HiveType(typeId: 23)
class Plan extends HiveObject{
  @HiveField(0)
  late String title;
  @HiveField(1)
  late int mainPrice;
  @HiveField(2)
  int? discount;
  @HiveField(3)
  int? fixDiscount;
  @HiveField(4)
  late int days;
  @HiveField(5)
  DateTime? startDate;
  @HiveField(6)
  DateTime? endDate;
  @HiveField(7)
  String? description;
  @HiveField(8)
  late String id;
  @HiveField(9)
  late String appName;
  @HiveField(10)
  late String type;
  @HiveField(11)
  late String platform;
  @HiveField(12)
  String? refId;

  num get price =>  discount != null
      ? mainPrice - mainPrice * discount! / 100
      : fixDiscount != null
      ? mainPrice - fixDiscount!
      :mainPrice;
  bool get hasDiscount =>fixDiscount==null && discount==null?false:
  endDate != null ? DateTime.now().isBefore(endDate!) : true;

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "type": type,
      "refId": refId,
      "appName": appName,
      "platform": platform,
      "mainPrice": mainPrice,
      "discount": discount,
      "fixDiscount": fixDiscount,
      "days": days,
      "startDate": startDate?.toIso8601String(),
      "endDate": endDate?.toIso8601String(),
      "description": description,
      "id": id,
    };
  }

  Plan fromMap(Map<String, dynamic> map) {
     Plan plan=Plan()
     ..title= map["title"] ?? ""
     ..type= map["type"] ?? ""
     ..refId= map["refId"]
     ..appName= map["appName"] ?? ""
     ..platform= map["platform"] ?? ""
     ..mainPrice= int.parse(map["mainPrice"]?? "-1")
     ..discount= int.parse(map["discount"] ?? "0")
     ..fixDiscount= int.parse(map["fixDiscount"] ?? "0")
     ..days=int.parse(map["days"] ?? "0")
     ..startDate= DateTime.tryParse(map["startDate"] ?? "0")
     ..endDate= DateTime.tryParse(map["endDate"] ?? "0")
     ..description= map["description"]
     ..id= map["id"] ?? "0";
    return plan;
  }
//
  String toJson() => json.encode(toMap());
  Plan fromJson(String source) => fromMap(jsonDecode(source));

}

//run this code for create adaptor:
//flutter packages pub run build_runner build --delete-conflicting-outputs
//dart run build_runner build --delete-conflicting-outputs