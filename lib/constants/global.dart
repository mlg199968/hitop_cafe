import 'package:flutter/cupertino.dart';
import 'package:hitop_cafe/services/storage_sevice.dart';

class Global {
  static late StorageService storageService;
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    storageService = await StorageService().init();
  }
}
