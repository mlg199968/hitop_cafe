import 'package:hitop_cafe/services/storage_sevice.dart';

class Global {
  static late StorageService storageService;
  static Future init() async {
    storageService = await StorageService().init();
  }
}
