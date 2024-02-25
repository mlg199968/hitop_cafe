import 'dart:async';

import 'package:hitop_cafe/models/shop.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/providers/ware_provider.dart';
import 'package:hitop_cafe/screens/side_bar/notice_screen/services/notice_tools.dart';
import 'package:hitop_cafe/services/backend_services.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:hitop_cafe/services/storage_service.dart';
import 'package:provider/provider.dart';

class GlobalTask {
  static late StorageService storageService;
  static Future init() async {
    storageService = await StorageService().init();
  }

  static getInitData(context)async{
    Provider.of<UserProvider>(context, listen: false).loadLevel();

    Provider.of<WareProvider>(context, listen: false).loadCategories();
    Shop shop=Shop();
    if(HiveBoxes.getShopInfo().values.isNotEmpty){
      shop = HiveBoxes.getShopInfo().values.single;
      Provider.of<UserProvider>(context, listen: false).getData(shop);
    }else{
      HiveBoxes.getShopInfo().add(shop);
    }
    ///get notifications
    runZonedGuarded(() => NoticeTools.readNotifications(context,timeout: 5),(e,trace){});
    if(Provider.of<UserProvider>(context, listen: false).level==0) {
      await BackendServices().fetchData(context);
    }
  }
}
