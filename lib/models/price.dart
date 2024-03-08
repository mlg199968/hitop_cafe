import 'dart:convert';

import 'package:hive/hive.dart';
part 'price.g.dart';

@HiveType(typeId: 22)
class Price extends HiveObject {
  @HiveField(0)
  late num mainPrice;
  @HiveField(1)
  int? discount;
  @HiveField(2)
  num? fixDiscount;
  @HiveField(3)
  DateTime? startDate;
  @HiveField(4)
  DateTime? endDate;
  @HiveField(5)
  int priceId = 0;

  num get price =>  discount != null
          ? mainPrice - mainPrice * discount! / 100
          : fixDiscount != null
      ? mainPrice - fixDiscount!
      :mainPrice;
  bool get hasDiscount =>fixDiscount==null && discount==null?false:
      endDate != null ? DateTime.now().isBefore(endDate!) : true;
  Map<String, dynamic> toMap() {
    return {
      'mainPrice': mainPrice,
      'discount': discount,
      'fixDiscount': fixDiscount,
      'startDate': startDate,
      'endDate': endDate,
      'priceId': priceId,
    };
  }

  Price fromMap(Map<String, dynamic> map) {
    Price price = Price()
      ..mainPrice = map['mainPrice'] ?? -1
      ..discount = map['discount']
      ..fixDiscount = map['fixDiscount']
      ..startDate = map['startDate']
      ..endDate = map['endDate']
      ..priceId = map['priceId'] ?? "0";
    return price;
  }

  String toJson() => jsonEncode(toMap());
  Price fromJson(String source) => fromMap(jsonDecode(source));
}

//run this code for create adaptor:
//flutter packages pub run build_runner build --delete-conflicting-outputs
//dart run build_runner build --delete-conflicting-outputs
