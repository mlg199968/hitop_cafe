

import 'dart:convert';

import 'package:hive/hive.dart';

part 'device.g.dart';

@HiveType(typeId: 20)
class Device extends HiveObject{
  @HiveField(0)
  late String platform;
  @HiveField(1)
  late String name;
  @HiveField(2)
  late String brand;
 @ HiveField(3)
  late String id;

  Device({
    required this.platform,
    required this.name,
    required this.brand,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'platform': platform,
      'name': name,
      'brand': brand,
      'id': id,
    };
  }

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      platform: map['platform']  ?? "",
      name: map['name'] ?? "",
      brand: map['brand'] ?? "",
      id: map['id'] ?? "",
    );
  }
  String toJson()=>jsonEncode(toMap());
  factory Device.fromJson(String source)=>Device.fromMap(jsonDecode(source));
}

//run this code for create adaptor:
//flutter packages pub run build_runner build --delete-conflicting-outputs
//dart run build_runner build --delete-conflicting-outputs