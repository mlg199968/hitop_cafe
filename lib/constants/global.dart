import 'package:hitop_cafe/models/shop.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/providers/ware_provider.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:hitop_cafe/services/storage_sevice.dart';
import 'package:provider/provider.dart';

class GlobalFunc {
  static late StorageService storageService;
  static Future init() async {
    storageService = await StorageService().init();
  }


  static getInitData(context){
    Provider.of<WareProvider>(context, listen: false).loadCategories();
    if(HiveBoxes.getShopInfo().values.isNotEmpty){
      Shop? shop = HiveBoxes.getShopInfo().values.first;
      Provider.of<UserProvider>(context, listen: false).getData(shop);
    }
  }
}
