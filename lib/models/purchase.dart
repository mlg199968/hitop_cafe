
import 'package:hive/hive.dart';
import 'dart:convert';


part 'purchase.g.dart';
@HiveType(typeId: 5)
class Purchase extends HiveObject {
  @HiveField(0)
  late String wareName;
  @HiveField(1)
  late String unit;
  @HiveField(2)
  num price=0;
  @HiveField(3)
  String description="";
  @HiveField(4)
  double quantity=0;
  @HiveField(5)
  late DateTime createDate;
  @HiveField(6)
  late String purchaseId;
  @HiveField(7)
  bool isChecked=false;
  @HiveField(8)
  num get sum =>quantity * price;
  @HiveField(9)
  num discount=0;
  @HiveField(10)
  num tax=0;



  Purchase({
    required this.wareName,
    required this.unit,
    required this.description,
    required this.price,
    required this.quantity,
    required this.createDate,
    required this.purchaseId,
    this.isChecked=false,
    this.discount=0,
    this.tax=0,
  });

  Map<String, dynamic> toMap() {
    return {
      'wareName': wareName,
      'unit': unit,
      'description': description,
      'price': price,
      'quantity': quantity,
      'createDate': createDate.toIso8601String(),
      'purchaseId': purchaseId,
      'isChecked': isChecked,
      'discount': discount,
      'tax': tax,

    };
  }

  factory Purchase.fromMap(Map<String, dynamic> map) {
    return Purchase(
      wareName: map['wareName'] ?? "",
      unit: map['unit'] ?? "",

      description: map['description'] ?? "",
      price: map['price'] ?? 0,
      quantity: map['quantity'] ?? 0,
      createDate: DateTime.parse(map['createDate']) ,
      purchaseId: map['purchaseId'] ?? "",
      isChecked: map['isChecked'] ==1 ? true :false,
      discount: map['discount'] ?? 0,
      tax: map['tax'] ?? 0,
    );
  }

String toJson()=>jsonEncode(toMap());
  Purchase fromJson(String source)=>Purchase.fromMap(jsonDecode(source));
}

//run this code for create adaptor:
//flutter packages pub run build_runner build --delete-conflicting-outputs