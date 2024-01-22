
import 'package:hive/hive.dart';
import 'dart:convert';


part 'raw_ware.g.dart';
@HiveType(typeId: 0)
class RawWare extends HiveObject {
  @HiveField(0)
  late String wareName;
  @HiveField(1)
  late String unit;
  @HiveField(2)
  late String category;
  @HiveField(3)
  String description="";
  @HiveField(4)
  num cost=0;
  @HiveField(5)
  double quantity=0;
  @HiveField(6)
  double demand=0;
  @HiveField(7)
  DateTime modifiedDate=DateTime.now();
  @HiveField(8)
  late DateTime createDate;
  @HiveField(9)
  late String wareId;
  @HiveField(10)
  bool isChecked=false;
  @HiveField(11)
  String? imagePath;
  @HiveField(12)
  String? color;
  @HiveField(13)
  num get sum =>quantity * cost;




  Map<String, dynamic> toMap() {
    return {
      'wareName': wareName,
      'unit': unit,
      'category': category,
      'description': description,
      'cost': cost,
      'quantity': quantity,
      'demand': demand,
      'modifiedDate': modifiedDate.toIso8601String(),
      'createDate': createDate.toIso8601String(),
      'wareId': wareId,
      'isChecked': isChecked,
      'imagePath': imagePath,
      'color': color,
    };
  }

   RawWare fromMap(Map<String, dynamic> map) {
     RawWare rawWare =RawWare()
     ..wareName= map['wareName'] ?? ""
     ..unit= map['unit'] ?? ""
     ..category= map['category'] ?? ""
     ..description= map['description'] ?? ""
     ..cost= map['cost'] as num
     ..quantity= map['quantity'] ?? 0
     ..demand= map['demand'] ?? 0
     ..modifiedDate=DateTime.parse (map['modifiedDate'])
     ..createDate= DateTime.parse(map['createDate'])
     ..wareId= map['wareId'] as String
     ..isChecked= map['isChecked'] ==1 ? true :false
     ..imagePath= map['imagePath']
     ..color= map['color'] ;
     return rawWare;
  }

String toJson()=>jsonEncode(toMap());
  RawWare fromJson(String source)=>fromMap(jsonDecode(source));
}

//run this code for create adaptor:
//flutter packages pub run build_runner build --delete-conflicting-outputs
//dart run build_runner build --delete-conflicting-outputs