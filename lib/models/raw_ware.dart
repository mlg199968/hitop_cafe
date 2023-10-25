
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

  RawWare({
    required this.wareName,
    required this.unit,
    required this.category,
    required this.description,
    required this.cost,
    required this.quantity,
    this.demand=0,
    required this.modifiedDate,
    required this.createDate,
    required this.wareId,
    this.isChecked=false,
    this.imagePath,
    this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'wareName': wareName,
      'unit': unit,
      'category': category,
      'description': description,
      'cost': cost,
      'quantity': quantity,
      'demand': demand,
      'modifiedDate': modifiedDate,
      'createDate': createDate,
      'wareId': wareId,
      'isChecked': isChecked,
      'imagePath': imagePath,
      'color': color,
    };
  }

  factory RawWare.fromMap(Map<String, dynamic> map) {
    return RawWare(
      wareName: map['wareName'] ?? "",
      unit: map['unit'] ?? "",
      category: map['category'] ?? "",
      description: map['description'] ?? "",
      cost: map['cost'] as num,
      quantity: map['quantity'] ?? 0,
      demand: map['demand'] ?? 0,
      modifiedDate: map['modifiedDate'] as DateTime,
      createDate: map['createDate'] as DateTime,
      wareId: map['wareId'] as String,
      isChecked: map['isChecked'] ==1 ? true :false,
      imagePath: map['imagePath'] ?? "",
      color: map['color'] ?? "",
    );
  }

String toJson()=>jsonEncode(toMap());
  RawWare fromJson(String source)=>RawWare.fromMap(jsonDecode(source));
}
