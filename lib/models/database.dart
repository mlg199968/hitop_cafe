import 'dart:convert';

import 'package:hitop_cafe/models/bill.dart';
import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/models/note.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/models/payment.dart';
import 'package:hitop_cafe/models/raw_ware.dart';
import 'package:hitop_cafe/models/user.dart';
import 'package:hive/hive.dart';


part 'database.g.dart';

@HiveType(typeId: 7)
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
  @HiveField(5)
  List<User>? customers = [];
  @HiveField(6)
  List<Note>? notes = [];
  @HiveField(7)
  List<Payment>? expenses = [];

  Map<String, dynamic> toMap() {
    return {
      'orders': orders.map((e) => e.toMap()).toList(),
      'bills': bills.map((e) => e.toMap()).toList(),
      'items': items.map((e) => e.toMap()).toList(),
      'wares': wares.map((e) => e.toMap()).toList(),
      'customers': (customers ?? []).map((e) => e.toMap()).toList(),
      'notes': (notes ?? []).map((e) => e.toMap()).toList(),
      'expenses': (expenses ?? []).map((e) => e.toMap()).toList(),
      'databaseId': databaseId,
    };
  }

  DB fromMap(Map<String, dynamic> map) {
    List<Item> items = List<Item>.from(
        map['items'].map((e) => Item().fromMap(e)));
    List<RawWare> wares =
        List<RawWare>.from(map['wares'].map((e) => RawWare().fromMap(e)));

    List<Order> orders = List<Order>.from(
        map['orders'].map((e) => Order().fromMap(e)));

    List<Bill> bills =
        List<Bill>.from(map['bills'].map((e) => Bill.fromMap(e)));

    List<User> customers =
        List<User>.from((map['customers'] ?? []).map((e) => User().fromMap(e)));

    List<Note> notes =
        List<Note>.from((map['notes'] ?? []).map((e) => Note().fromMap(e)));

    List<Payment> expenses =
        List<Payment>.from((map['expenses'] ?? []).map((e) => Payment().fromMap(e)));


    DB db = DB()
      ..orders = orders
      ..bills = bills
      ..items = items
      ..wares = wares
      ..customers = customers
      ..notes = notes
      ..expenses = expenses
      ..databaseId = map['databaseId'] ?? "";
    return db;
  }

  String toJson() => jsonEncode(toMap());
  DB fromJson(String source) => fromMap(jsonDecode(source));
}

//run this code for create adaptor:
//flutter packages pub run build_runner build --delete-conflicting-outputs
