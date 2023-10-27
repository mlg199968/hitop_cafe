import 'dart:convert';

import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/models/payment.dart';
import 'package:hive/hive.dart';

part 'order.g.dart';
@HiveType(typeId: 2)
class Order extends HiveObject {
  @HiveField(0)
  List<Item> items = [];
  @HiveField(1)
  int? tableNumber;
  @HiveField(2)
  List<Payment> payments = [];
  @HiveField(3)
  String description = "";
  @HiveField(4)
  late num payable;
  @HiveField(5)
  num get itemsSum => items.isEmpty?0:items.map((e) => e.sale).reduce((a, b) => a + b);
  @HiveField(6)
  num get cashSum => payments.isEmpty?0:payments.map((e) =>e.method=="cash"? e.amount:0).reduce((a, b) => a + b);
  @HiveField(7)
  num get atmSum =>payments.isEmpty?0: payments.map((e) => e.method=="atm"?e.amount:0).reduce((a, b) => a + b);
  @HiveField(8)
  num discount = 0;
  @HiveField(9)
  late DateTime orderDate;
  @HiveField(10)
  late String orderId;
  @HiveField(11)
  DateTime modifiedDate = DateTime.now();
  @HiveField(12)
  DateTime? dueDate;
  @HiveField(13)
  bool isChecked = false;
  @HiveField(14)
  bool isDone = false;


  Order({
    required this.items,
    this.tableNumber,
    required this.payments,
    required this.payable,
    required this.discount,
    required this.orderDate,
    required this.orderId,
    required this.modifiedDate,
    this.dueDate,
    this.isChecked=false,
    this.isDone=false,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
      'tableNumber': tableNumber,
      'payments': payments.map((payment) => payment.toMap()).toList(),
      'payable': payable,
      'discount': discount,
      'orderDate': orderDate.toIso8601String(),
      'orderId': orderId,
      'modifiedDate': modifiedDate.toIso8601String(),
      'dueDate': dueDate!=null? dueDate!.toIso8601String():null,
      'isChecked': isChecked?1:0,
      'isDone': isDone?1:0,
      'description': description,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    List<Item> items=List<Item>.from((map['items'] as List).map((e)=>Item.fromMap(e),),);
    List<Payment> payments=List<Payment>.from((map['payments'] as List).map((e)=>Payment.fromMap(e),),);
    return Order(
      items: items,
      tableNumber: map['tableNumber'] ?? 0,
      payments: payments,
      payable: map['payable'] ?? 0,
      discount: map['discount'] ?? 0,
      orderDate:DateTime.parse( map['orderDate']) ,
      orderId: map['orderId'] ?? "",
      modifiedDate: DateTime.parse(map['modifiedDate']) ,
      dueDate: map['dueDate']!=null?DateTime.parse(map['dueDate']):null,
      isChecked: map['isChecked']==1?true:false,
      isDone: map['isDone']==1?true:false,
      description: map['description'] ?? "",
    );
  }
  String toJson()=>jsonEncode(toMap());
  factory Order.fromJson(String source)=>Order.fromMap(jsonDecode(source));
}


//run this code for create adaptor:
//flutter packages pub run build_runner build --delete-conflicting-outputs