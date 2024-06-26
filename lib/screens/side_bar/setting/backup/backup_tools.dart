import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hitop_cafe/constants/consts_class.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/error_handler.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/bill.dart';
import 'package:hitop_cafe/models/database.dart';
import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/models/note.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/models/payment.dart';
import 'package:hitop_cafe/models/raw_ware.dart';
import 'package:hitop_cafe/models/user.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';

import 'package:intl/intl.dart' as intl;
import 'package:path_provider/path_provider.dart';

class BackupTools {
  BackupTools({this.quickBackup = false});
  final bool quickBackup;
  static const String _outPutName = "data-file.mlg";
  final String formattedDate =
      intl.DateFormat('yyyyMMdd-kkmmss').format(DateTime.now());
  String get zipFileName => quickBackup
      ? "hitop-cafe$formattedDate-database.chc"
      : "hitop-cafe$formattedDate-full.chc";

  static Future<String?> chooseDirectory() async {
    String? result = await FilePicker.platform
        .getDirectoryPath(dialogTitle: "انتخاب مکان ذخیره فایل پشتیبان");
    if (result != null) {
      return result;
    } else {
      return null;
    }
  }

  static Future<void> _restoreJsonData(File json, context) async {
    try {
      String jsonFile = await json.readAsString();
      DB restoredDb = DB().fromJson(jsonFile);

      for (int i = 0; i < restoredDb.wares.length; i++) {
        HiveBoxes.getRawWare()
            .put(restoredDb.wares[i].wareId, restoredDb.wares[i]);
      }
      for (int i = 0; i < restoredDb.items.length; i++) {
        HiveBoxes.getItem()
            .put(restoredDb.items[i].itemId, restoredDb.items[i]);
      }
      for (int i = 0; i < restoredDb.orders.length; i++) {
        HiveBoxes.getOrders()
            .put(restoredDb.orders[i].orderId, restoredDb.orders[i]);
      }
      for (int i = 0; i < restoredDb.bills.length; i++) {
        HiveBoxes.getBills()
            .put(restoredDb.bills[i].billId, restoredDb.bills[i]);
      }
      if (restoredDb.customers != null) {
        for (int i = 0; i < restoredDb.customers!.length; i++) {
          HiveBoxes.getCustomers()
              .put(restoredDb.customers![i].userId, restoredDb.customers![i]);
        }
      }
      if (restoredDb.notes != null) {
        for (int i = 0; i < restoredDb.notes!.length; i++) {
          HiveBoxes.getNotes()
              .put(restoredDb.notes![i].noteId, restoredDb.notes![i]);
        }
      }
      if (restoredDb.expenses != null) {
        for (int i = 0; i < restoredDb.expenses!.length; i++) {
          HiveBoxes.getExpenses()
              .put(restoredDb.expenses![i].paymentId, restoredDb.expenses![i]);
        }
      }

      showSnackBar(context, "فایل پشتیبان با موفقیت بارگیری شد !",
          type: SnackType.success);
    } catch (e, stack) {
      ErrorHandler.errorManger(context, e,
          stacktrace: stack,
          title: "BackupTools - restoreJsonData error",
          showSnackbar: true);
    }
  }

  ///create backup zip file
  Future<void> createBackup(context, {String? directory}) async {
    List<Bill> bills = HiveBoxes.getBills().values.toList();
    List<Item> items = HiveBoxes.getItem().values.toList();
    List<RawWare> wares = HiveBoxes.getRawWare().values.toList();
    List<Order> orders = HiveBoxes.getOrders().values.toList();
    List<User> customers = HiveBoxes.getCustomers().values.toList();
    List<Note> notes = HiveBoxes.getNotes().values.toList();
    List<Payment> expenses = HiveBoxes.getExpenses().values.toList();

    DB database = DB()
      ..wares = wares
      ..items = items
      ..orders = orders
      ..expenses = expenses
      ..customers = customers
      ..notes = notes
      ..bills = bills;

    // await _saveJson(database.toJson(),context);
    if (directory != null && directory != "") {
      await createZipFile(database.toJson(), context, directory: directory);
    } else {
      showSnackBar(context, "مسیر ذخیره سازی انتخاب نشده است!",
          type: SnackType.warning);
    }
  }

  ///read backup zip file
  static Future<void> readZipFile(context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        await Address.itemsImage();
        await Address.customersImage();
        String appPath = await Address.appDirectory();
        String directory = (await getApplicationDocumentsDirectory()).path;
        String path = result.files.single.path!;
        final bytes = File(path).readAsBytesSync();
        // Decode the Zip file
        final archive = ZipDecoder().decodeBytes(bytes);
        // Extract the contents of the Zip archive to disk.
        for (final file in archive) {
          final filename = file.name;

          if (file.isFile) {
            final data = file.content as List<int>;
            File extractedFile = File('$directory/$filename')
              ..createSync(recursive: true)
              ..writeAsBytesSync(data);
            if (filename == _outPutName) {
              await _restoreJsonData(extractedFile, context);
            } else if (filename.contains("items")) {
              await extractedFile.copy("$appPath/$filename");
            } else if (filename.contains("customers")) {
              await extractedFile.copy("$appPath/$filename");
            }
          } else {
            await Directory('$directory/$filename').create(recursive: true);
          }
        }
      }
      await updateImagePath();
    } catch (e, stacktrace) {
      ErrorHandler.errorManger(context, e,
          route: stacktrace.toString(),
          title: "BackupTools - readZipFile error",
          showSnackbar: true);
    }
  }

  ///create zip file
  createZipFile(String json, context, {required String directory}) async {
    try {
      String itemDir = await Address.itemsDirectory();
      String customerDir = await Address.customersDirectory();

      // Zip a directory to out.zip using the zipDirectory convenience method
      var encoder = ZipFileEncoder();
      // encoder.zipDirectory(Directory(result),
      //     filename: 'hitop-cafe$formattedDate.zip');

      // Manually create a zip of a directory and individual files.
      encoder.create('$directory/$zipFileName');
      if (quickBackup == false) {
        encoder.addDirectory(Directory(itemDir));
        encoder.addDirectory(Directory(customerDir));
      }
      File jsonFile = await _createJsonFile(json, directory);
      encoder.addFile(jsonFile);
      encoder.close();
      await jsonFile.delete(recursive: true);
      showSnackBar(context, "فایل پشتیبان با موفقیت ذخیره شد !",
          type: SnackType.success);
    } catch (e) {
      ErrorHandler.errorManger(context, e,
          title: "BackupTools - createZipFile error", showSnackbar: true);
    }
  }

  ///create json file
  static Future<File> _createJsonFile(String json, String path) async {
    File createdFile = File("$path/$_outPutName");
    await createdFile.create(recursive: true);
    await createdFile.writeAsString(json);
    return createdFile;
  }

  /// update image path if device change
  static Future<void> updateImagePath() async {
    String itemsImagePath = await Address.itemsImage();
    String customerImagePath = await Address.customersImage();
    List<Item> itemsList = HiveBoxes.getItem().values.toList();
    List<User> customerList = HiveBoxes.getCustomers().values.toList();
    //item update image path *****
    for (Item item in itemsList) {
      String imagePath = "$itemsImagePath/${item.itemId}.jpg";
      if (await File(imagePath).exists()) {
        item.imagePath = imagePath;
      } else {
        item.imagePath = null;
      }
      HiveBoxes.getItem().put(item.itemId, item);
    }
    //customers update image path *****
    for (User customer in customerList) {
      String imagePath = "$customerImagePath/${customer.userId}.jpg";
      if (await File(imagePath).exists()) {
        customer.image = imagePath;
      } else {
        customer.image = null;
      }
      HiveBoxes.getCustomers().put(customer.userId, customer);
    }
  }
}
