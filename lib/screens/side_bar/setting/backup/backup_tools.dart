import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/bill.dart';
import 'package:hitop_cafe/models/database.dart';
import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/models/raw_ware.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';

import 'package:intl/intl.dart' as intl;


class BackupTools {


  static Future<void> createBackup(BuildContext context) async{
    try {
      List<Bill> bills = HiveBoxes
          .getBills()
          .values
          .toList();
      List<Item> items = HiveBoxes
          .getItem()
          .values
          .toList();
      List<RawWare> wares = HiveBoxes
          .getRawWare()
          .values
          .toList();
      List<Order> orders = HiveBoxes
          .getOrders()
          .values
          .toList();

      DB database = DB()
        ..wares = wares
        ..items = items
        ..orders = orders
        ..bills = bills;

      await _saveJson(database.toJson(),context);

    }catch(e){
      if(context.mounted) {
        showSnackBar(context, e.toString(),type: SnackType.error);
      }
    }
  }

  static Future<void> restoreBackup(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        File backupFile = File(result.files.single.path!);
        String jsonFile = await backupFile.readAsString();
        DB restoredDb = DB().fromJson(jsonFile);

        for (int i = 0; i < restoredDb.bills.length; i++) {
          HiveBoxes.getBills().put(
              restoredDb.bills[i].billId, restoredDb.bills[i]);
        }
        for (int i = 0; i < restoredDb.items.length; i++) {
          HiveBoxes.getItem().put(
              restoredDb.items[i].itemId, restoredDb.items[i]);
        }
        for (int i = 0; i < restoredDb.wares.length; i++) {
          HiveBoxes.getRawWare().put(
              restoredDb.wares[i].wareId, restoredDb.wares[i]);
        }
        for (int i = 0; i < restoredDb.orders.length; i++) {
          HiveBoxes.getOrders().put(
              restoredDb.orders[i].orderId, restoredDb.orders[i]);
        }

        if(context.mounted) {
          showSnackBar(context, "فایل پشتیبان با موفقیت بارگیری شد !",type: SnackType.success);
      }

      }
    }catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
      if(context.mounted) {

        showSnackBar(context, e.toString(),type: SnackType.error);
      }
    }
  }


  static Future<void> _saveJson(String json,BuildContext context) async {
    String formattedDate= intl.DateFormat('yyyyMMdd-kkmmss').format(DateTime.now());

    String? result = await FilePicker.platform.getDirectoryPath(dialogTitle: "انتخاب مکان ذخیره فایل پشتیبان");
    if (result != null) {
      String path = result;
      File createdFile =
      File("$path/$formattedDate.mlg");
      createdFile.create(recursive: true);
      createdFile.writeAsString(json);
      if(context.mounted) {
        showSnackBar(context, "فایل پشتیبان با موفقیت ذخیره شد !",type: SnackType.success);
      }
    }
  }
}

