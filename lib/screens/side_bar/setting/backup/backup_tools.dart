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
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/models/raw_ware.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';

import 'package:intl/intl.dart' as intl;
import 'package:path_provider/path_provider.dart';

class BackupTools {
  static const String _outPutName = "data-file.mlg";

  static Future<String?> chooseDirectory() async {
    String? result = await FilePicker.platform
        .getDirectoryPath(dialogTitle: "انتخاب مکان ذخیره فایل پشتیبان");
    if(result!=null){
      return result;
    }else{
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

      showSnackBar(context, "فایل پشتیبان با موفقیت بارگیری شد !",
          type: SnackType.success);
    } catch (e) {
      ErrorHandler.errorManger(context, e,
          title: "BackupTools - restoreJsonData error", showSnackbar: true);
    }
  }
///create backup zip file
  static Future<void> createBackup(context,{String? directory}) async {
    try {
      List<Bill> bills = HiveBoxes.getBills().values.toList();
      List<Item> items = HiveBoxes.getItem().values.toList();
      List<RawWare> wares = HiveBoxes.getRawWare().values.toList();
      List<Order> orders = HiveBoxes.getOrders().values.toList();

      DB database = DB()
        ..wares = wares
        ..items = items
        ..orders = orders
        ..bills = bills;

      // await _saveJson(database.toJson(),context);
      if(directory!=null && directory!="") {
        await createZipFile(
            await Address.itemsImage(), database.toJson(), context,
            directory: directory);
      }else{
        showSnackBar(context, "مسیر ذخیره سازی انتخاب نشده است!",type: SnackType.warning);
      }
    } catch (e) {
      ErrorHandler.errorManger(context, e,
          title: "BackupTools - createBackup error", showSnackbar: true);
    }
  }
  ///read backup zip file
  static Future<void> readZipFile(context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        await Address.itemsImage();
        String imagesPath = await Address.itemsDirectory();
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
            } else {
              await extractedFile.copy("$imagesPath/$filename");
            }
          } else {
            await Directory('$directory/$filename').create(recursive: true);
          }
        }
      }
     await updateImagePath();
    } catch (e) {
      ErrorHandler.errorManger(context, e,
          title: "BackupTools - readZipFile error", showSnackbar: true);
    }
  }
///create zip file
  static createZipFile(String imagesDir, String json, context,{required String directory}) async {
    try {
      String formattedDate =
          intl.DateFormat('yyyyMMdd-kkmmss').format(DateTime.now());


        // Zip a directory to out.zip using the zipDirectory convenience method
        var encoder = ZipFileEncoder();
        // encoder.zipDirectory(Directory(result),
        //     filename: 'hitop-cafe$formattedDate.zip');

        // Manually create a zip of a directory and individual files.
        encoder.create('$directory/hitop-cafe$formattedDate.zip');
        encoder.addDirectory(Directory(imagesDir));
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

  static Future<File> _createJsonFile(String json, String path) async {
    File createdFile = File("$path/$_outPutName");
    await createdFile.create(recursive: true);
    await createdFile.writeAsString(json);
    return createdFile;
  }


///
 static Future<void> updateImagePath()async{
   String directoryPath=await Address.itemsImage();
    List<Item> itemsList=HiveBoxes.getItem().values.toList();
   for (int i = 0; i < itemsList.length; i++) {
     String id=itemsList[i].itemId;
     String imagePath="$directoryPath/$id.jpg";
     if(await File(imagePath).exists()) {
       itemsList[i].imagePath=imagePath;
     }else{
       itemsList[i].imagePath=null;
     }
     HiveBoxes.getItem()
         .put(id,itemsList[i]);
   }

  }
  // static Future<void> _saveJson(String json, context) async {
  //   String formattedDate =
  //       intl.DateFormat('yyyyMMdd-kkmmss').format(DateTime.now());
  //
  //   String? result = await FilePicker.platform
  //       .getDirectoryPath(dialogTitle: "انتخاب مکان ذخیره فایل پشتیبان");
  //   if (result != null) {
  //     String path = result;
  //     File createdFile = File("$path/$formattedDate.mlg");
  //     createdFile.create(recursive: true);
  //     createdFile.writeAsString(json);
  //
  //     showSnackBar(context, "فایل پشتیبان با موفقیت ذخیره شد !",
  //         type: SnackType.success);
  //   }
  // }
}
