import 'dart:convert';

import 'package:hitop_cafe/models/bill.dart';
import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/models/raw_ware.dart';
import 'package:hive/hive.dart';


part 'database.g.dart';

@HiveType(typeId: 6)
class DB extends HiveObject {
  @HiveField(0)
  List<Order> orders = [];
  @HiveField(1)
  List<Bill> bills = [];
  @HiveField(2)
  List<Item> items = [];
  @HiveField(3)
  List<RawWare> wares = [];
  @HiveField(4)
  String databaseId = "09152361766";

  Map<String, dynamic> toMap() {
    return {
      'orders': orders.map((e) => e.toMap()).toList(),
      'bills': bills.map((e) => e.toMap()).toList(),
      'items': items.map((e) => e.toMap()).toList(),
      'wares': wares.map((e) => e.toMap()).toList(),
      'databaseId': databaseId,
    };
  }

  DB fromMap(Map<String, dynamic> map) {
    List<Item> items = List<Item>.from(
        map['items'].map((e) => Item().fromMap(e)));
    List<RawWare> wares =
        List<RawWare>.from(map['wares'].map((e) => RawWare.fromMap(e)));

    List<Order> orders = List<Order>.from(
        map['orders'].map((e) => Order().fromMap(e)));

    List<Bill> bills =
        List<Bill>.from(map['bills'].map((e) => Bill.fromMap(e)));


    DB db = DB()
      ..orders = orders
      ..bills = bills
      ..items = items
      ..wares = wares
      ..databaseId = map['databaseId'] ?? "";
    return db;
  }

  String toJson() => jsonEncode(toMap());
  DB fromJson(String source) => fromMap(jsonDecode(source));
}

//run this code for create adaptor:
//flutter packages pub run build_runner build --delete-conflicting-outputs
