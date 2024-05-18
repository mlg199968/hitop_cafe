

import 'dart:convert';

import 'package:hive/hive.dart';

part 'payment.g.dart';
@HiveType(typeId: 3)
class Payment extends HiveObject{
  @HiveField(0)
  late num amount;
  @HiveField(1)
  String? method="";
  @HiveField(2)
  String paymentId="0";
  @HiveField(3)
  late DateTime deliveryDate;
  @HiveField(4)
  bool isChecked=false;
  @HiveField(5)
  String? description;
  @HiveField(6)
  DateTime? chequeDate;
  @HiveField(7)
  String? chequeSerial="";
  @HiveField(8)
  String? ownerName;
  @HiveField(9)
  String? ownerPhone;
  @HiveField(10)
  bool? isDone=false;

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'method': method,
      'paymentId': paymentId,
      'deliveryDate': deliveryDate.toIso8601String(),
      'chequeDate': chequeDate?.toIso8601String(),
      'chequeSerial': chequeSerial,
      'ownerName': ownerName,
      'ownerPhone': ownerPhone,
      'description': description,
      'isDone': isDone==true ?1:0,
      'isChecked': isChecked?1:0,
    };
  }

  Payment fromMap(Map<String, dynamic> map) {
    Payment payment= Payment()
      ..amount= map['amount'] ?? 0
      ..method= map['method'] ?? ""
      ..paymentId= map['paymentId'] ?? ""
      ..deliveryDate= map['deliveryDate']==null?DateTime.now(): DateTime.parse(map['deliveryDate'])
      ..chequeDate= map['chequeDate']==null?DateTime.now(): DateTime.parse(map['chequeDate'])
      ..chequeSerial= map['chequeSerial']
      ..ownerName= map['ownerName']
      ..ownerPhone= map['ownerPhone']
      ..description= map['description']
      ..isDone= map['isDone']==1?true:false
      ..isChecked= map['isChecked']==1?true:false;

    return payment;
  }



  String toJson()=>jsonEncode(toMap());
  Payment fromJson(String source)=>fromMap(jsonDecode(source));

}






//run this code for create adaptor:
//flutter packages pub run build_runner build --delete-conflicting-outputs
//dart run build_runner build --delete-conflicting-outputs