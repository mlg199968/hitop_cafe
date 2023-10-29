import 'dart:convert';
import 'package:hitop_cafe/models/payment.dart';
import 'package:hitop_cafe/models/purchase.dart';
import 'package:hitop_cafe/models/raw_ware.dart';
import 'package:hive/hive.dart';

part 'bill.g.dart';
@HiveType(typeId: 4)
class Bill extends HiveObject {
  @HiveField(0)
  List<Purchase> purchases = [];
  @HiveField(1)
  int billNumber;
  @HiveField(2)
  List<Payment> payments = [];
  @HiveField(3)
  String description = "";
  @HiveField(4)
  late num payable;
  @HiveField(5)
  num get waresSum => purchases.isEmpty?0:purchases.map((e) => e.price).reduce((a, b) => a + b);
  @HiveField(6)
  num get cashSum => payments.isEmpty?0:payments.map((e) =>e.method=="cash"? e.amount:0).reduce((a, b) => a + b);
  @HiveField(7)
  num get atmSum =>payments.isEmpty?0: payments.map((e) => e.method=="atm"?e.amount:0).reduce((a, b) => a + b);
  @HiveField(8)
  num discount = 0;
  @HiveField(9)
  late DateTime billDate;
  @HiveField(10)
  late String billId;
  @HiveField(11)
  DateTime modifiedDate = DateTime.now();
  @HiveField(12)
  DateTime? dueDate;
  @HiveField(13)
  bool isChecked = false;
  @HiveField(14)
  bool isDone = false;




  Bill({
    required this.purchases,
    required this.payments,
    required this.payable,
    required this.discount,
    required this.billDate,
    required this.billId,
    required this.modifiedDate,
    this.dueDate,
    this.isChecked=false,
    this.isDone=false,
    required this.description,
    this.billNumber=0,
  });

  Map<String, dynamic> toMap() {
    return {
      'purchases': purchases.map((purchase) => purchase.toMap()).toList(),
      'payments': payments.map((payment) => payment.toMap()).toList(),
      'payable': payable,
      'discount': discount,
      'billDate': billDate.toIso8601String(),
      'billId': billId,
      'modifiedDate': modifiedDate.toIso8601String(),
      'dueDate': dueDate!=null? dueDate!.toIso8601String():null,
      'isChecked': isChecked?1:0,
      'isDone': isDone?1:0,
      'description': description,
      'billNumber': billNumber,
    };
  }

  factory Bill.fromMap(Map<String, dynamic> map) {
    List<Purchase> purchases=List<Purchase>.from((map['purchases'] as List).map((e)=>Purchase.fromMap(e),),);
    List<Payment> payments=List<Payment>.from((map['payments'] as List).map((e)=>Payment.fromMap(e),),);
    return Bill(
      purchases: purchases,
      payments: payments,
      payable: map['payable'] ?? 0,
      discount: map['discount'] ?? 0,
      billDate:DateTime.parse( map['billDate']) ,
      billId: map['billId'] ?? "",
      modifiedDate: DateTime.parse(map['modifiedDate']) ,
      dueDate: map['dueDate']!=null?DateTime.parse(map['dueDate']):null,
      isChecked: map['isChecked']==1?true:false,
      isDone: map['isDone']==1?true:false,
      description: map['description'] ?? "",
      billNumber: map['billNumber'] ?? 0,
    );
  }
  String toJson()=>jsonEncode(toMap());
  factory Bill.fromJson(String source)=>Bill.fromMap(jsonDecode(source));
}


//run this code for create adaptor:
//flutter packages pub run build_runner build --delete-conflicting-outputs