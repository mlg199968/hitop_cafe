import 'package:hitop_cafe/models/shop.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/providers/ware_provider.dart';
import 'package:hitop_cafe/screens/side_bar/notice_screen/services/notice_tools.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:hitop_cafe/services/storage_service.dart';
import 'package:provider/provider.dart';

class GlobalTask {
  static late StorageService storageService;
  static Future init() async {
    storageService = await StorageService().init();
  }


  static getInitData(context)async{
    Provider.of<WareProvider>(context, listen: false).loadCategories();
    if(HiveBoxes.getShopInfo().values.isNotEmpty){
      Shop? shop = HiveBoxes.getShopInfo().values.single;
      Provider.of<UserProvider>(context, listen: false).getData(shop);
    }
    ///get notifications
    if(context.mounted) {
      await NoticeTools.readNotifications(context,timeout: 5);
    }
  }
}
