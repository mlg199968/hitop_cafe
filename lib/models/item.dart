
import 'dart:convert';

import 'package:hitop_cafe/models/raw_ware.dart';
import 'package:hive/hive.dart';

part 'item.g.dart';
@HiveType(typeId:1)
class Item extends HiveObject{
  @HiveField(0)
  late String itemName;
  @HiveField(1)
  late String unit;
  @HiveField(2)
  late String category;
  @HiveField(3)
  String description="";
  @HiveField(4)
  num sale=0;
  @HiveField(5)
  late List<RawWare> ingredients;
  @HiveField(6)
  DateTime modifiedDate=DateTime.now();
  @HiveField(7)
  late DateTime createDate;
  @HiveField(8)
  late String itemId;
  @HiveField(9)
  bool? isChecked=false;
  @HiveField(10)
  String? imagePath;
  @HiveField(11)
  String? color;
 @HiveField(12)
  num? quantity=1;
@HiveField(13)
  num? discount=0;
@HiveField(14)
  num get sum =>(quantity ?? 1) * sale;




  Map<String, dynamic> toMap() {
    return {
      'itemName': itemName,
      'unit': unit,
      'category': category,
      'description': description,
      'sale': sale,
      'ingredients': ingredients.map((e) => e.toMap()).toList(),
      'modifiedDate': modifiedDate.toIso8601String(),
      'createDate': createDate.toIso8601String(),
      'itemId': itemId,
      'isChecked': isChecked,
      'imagePath': imagePath,
      'color': color,
'quantity': quantity,
'discount': discount,

    };
  }

  Item fromMap(Map<String, dynamic> map) {

    List<RawWare> ingredients = List<RawWare>.from(
        (map['ingredients']).map((e) => RawWare.fromMap(e)));

     Item item=Item ()
      ..itemName= map['itemName'] ?? ""
      ..unit= map['unit'] as String
      ..category= map['category'] ?? ""
      ..description= map['description']
      ..sale= map['sale'] as num
      ..ingredients= ingredients
      ..modifiedDate= DateTime.parse(map['modifiedDate'])
      ..createDate= DateTime.parse(map['createDate'])
      ..itemId= map['itemId'] as String
      ..isChecked= map['isChecked'] == 1 ? true : false
      ..imagePath= map['imagePath']
      ..color= map['color']
      ..quantity= map['quantity'] ?? 0
      ..discount= map['discount'] ?? 0
    ;
    return item;
  }

  String toJson() => jsonEncode(toMap());
  Item fromJson(String source) => fromMap(jsonDecode(source));
}

//run this code for create adaptor:
//flutter packages pub run build_runner build --delete-conflicting-outputs