import 'dart:convert';

import 'package:hitop_cafe/constants/consts_class.dart';
import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/models/payment.dart';
import 'package:hitop_cafe/models/user.dart';
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
  String? description;
  @HiveField(4)
  String? orderType;
  @HiveField(5)
  late DateTime orderDate;
  @HiveField(6)
  late String orderId;
  @HiveField(7)
  DateTime modifiedDate = DateTime.now();
  @HiveField(8)
  DateTime? dueDate;
  @HiveField(9)
  bool isChecked = false;
  @HiveField(10)
  bool isDone = false;
  @HiveField(11)
  int? billNumber;
  @HiveField(12)
  int? tax;
 @HiveField(13)
  User? user;
 @HiveField(14)
  User? customer;
 @HiveField(15)
  bool? takeaway;

  num get payable=>itemsSum-paymentSum-itemsDiscount;
  //
  num get itemsSum => items.isEmpty?0:items.map((e) => e.sale*e.quantity).reduce((a, b) => a + b);
  //
  num get paymentSum => payments.isEmpty?0:payments.map((e) =>e.amount).reduce((a, b) => a + b);
  //
  num get cashSum => payments.isEmpty?0:payments.map((e) =>e.method==PayMethod.cash? e.amount:0).reduce((a, b) => a + b);
  //
  num get atmSum =>payments.isEmpty?0: payments.map((e) => e.method==PayMethod.atm? e.amount:0).reduce((a, b) => a + b);
  //
  num get cardSum =>payments.isEmpty?0: payments.map((e) => e.method==PayMethod.card? e.amount:0).reduce((a, b) => a + b);
  //
  num get itemsDiscount => items.isEmpty
      ? 0
      : items.map((e) => e.discount! * .01 * e.sum).reduce((a, b) => a + b);
  //
  num get paymentDiscount => payments.isEmpty
      ? 0
      : payments
      .map((e) => e.method == PayMethod.discount ? e.amount : 0)
      .reduce((a, b) => a + b);
  //
  ///calculate all discount
  num get discount => paymentDiscount+itemsDiscount;

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
      'tableNumber': tableNumber,
      'payments': payments.map((payment) => payment.toMap()).toList(),
      'orderDate': orderDate.toIso8601String(),
      'orderId': orderId,
      'orderType': orderType,
      'modifiedDate': modifiedDate.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'isChecked': isChecked?1:0,
      'isDone': isDone?1:0,
      'description': description,
      'billNumber': billNumber,
      'tax': tax,
      'user': user?.toMap(),
      'customer': customer?.toMap(),
    };
  }

  Order fromMap(Map<String, dynamic> map) {
    List<Item> mapItems=map['items']==null?[]:List<Item>.from((map['items'] as List).map((e)=>Item().fromMap(e),),);
    List<Payment> mapPayments=map['payments']==null?[]:List<Payment>.from((map['payments'] as List).map((e)=>Payment().fromMap(e),),);
    Order order=Order()
      ..items= mapItems
      ..tableNumber= map['tableNumber'] ?? 0
      ..payments= mapPayments
      ..orderDate=map['orderDate']!=null?DateTime.parse( map['orderDate']):DateTime.now()
      ..orderId= map['orderId'] ?? ""
      ..orderType= map['orderType']
      ..modifiedDate=map['modifiedDate']!=null? DateTime.parse(map['modifiedDate']):DateTime.now()
      ..dueDate= map['dueDate']!=null?DateTime.parse(map['dueDate']):null
      ..isChecked= map['isChecked']==1?true:false
      ..isDone= map['isDone']==1?true:false
      ..description= map['description'] ?? ""
      ..user= map['user']==null?null:User().fromMap(map['user'])
      ..customer= map['customer']==null?null:User().fromMap(map['customer'])
      ..tax= map['tax'] ?? 0
      ..billNumber= map['billNumber'] ?? 0;

    return order;
  }
  String toJson()=>jsonEncode(toMap());
   Order fromJson(String source)=>fromMap(jsonDecode(source));
}


//run this code for create adaptor:
//flutter packages pub run build_runner build --delete-conflicting-outputs
//dart run build_runner build --delete-conflicting-outputs