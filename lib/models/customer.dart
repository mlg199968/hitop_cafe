import 'dart:convert';

import 'package:hive/hive.dart';

part 'customer.g.dart';

@HiveType(typeId: 18)
class Customer extends HiveObject {
  @HiveField(0)
  String firstName="";
  @HiveField(1)
  String lastName="";
  @HiveField(2)
  String nickName="";
  @HiveField(3)
  String phoneNumber="";
  @HiveField(4)
  String phoneNumber2="";
  @HiveField(5)
  String description="";
  @HiveField(6)
  DateTime date=DateTime.now();
  @HiveField(7)
  num score=5;
  @HiveField(8)
  late String customerId;
  @HiveField(9)
  bool? isChecked=false;
  @HiveField(10)
  DateTime? modifiedDate=DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'nickName': nickName,
      'phoneNumber': phoneNumber,
      'phoneNumber2': phoneNumber2,
      'description': description,
      'date': date.toIso8601String(),
      'modifiedDate': modifiedDate!=null?modifiedDate!.toIso8601String():DateTime.now().toIso8601String(),
      'score': score,
      'customerId': customerId,
      'isChecked': isChecked! ? 1 : 0,
    };
  }

  Customer fromMap(Map<String, dynamic> map) {
    Customer customerHive=Customer()
      ..firstName= map['firstName'] ?? ""
      ..lastName= map['lastName'] ?? ""
      ..nickName= map['nickName'] ?? ""
      ..phoneNumber= map['phoneNumber'] ?? ""
      ..phoneNumber2= map['phoneNumber2'] ?? ""
      ..description= map['description'] ?? ""
      ..date= DateTime.parse(map['date'])
      ..modifiedDate= map['modifiedDate']==null ? DateTime.now() :DateTime.parse(map['modifiedDate'])
      ..score= map['score'] ?? 0
      ..customerId= map['customerId'] ?? ""
      ..isChecked= map['isChecked']==1?true:false;
    return customerHive;
  }
  String toJson() => jsonEncode(toMap());
  Customer fromJson(String source) => fromMap(jsonDecode(source));
}



//run this code for create adaptor:
//flutter packages pub run build_runner build --delete-conflicting-outputs
//dart run build_runner build --delete-conflicting-outputs