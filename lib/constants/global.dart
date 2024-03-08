import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
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

  static Future<void> getInitData(context)async{

    Provider.of<WareProvider>(context, listen: false).loadCategories();
    Shop shop=Shop();
    if(HiveBoxes.getShopInfo().values.isNotEmpty){
      shop = HiveBoxes.getShopInfo().values.single;
      Provider.of<UserProvider>(context, listen: false).getData(shop);
    }else{
      HiveBoxes.getShopInfo().add(shop);
    }

    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.ethernet ||
        connectivityResult == ConnectivityResult.vpn) {
      print("connectivityResult");
      print(connectivityResult);
      /// fetch subscription data
      BackendServices().fetchSubscription(context).whenComplete(() {
        print("fetchSubscription completed");
      });
      ///get notifications
      runZonedGuarded(() => NoticeTools.readNotifications(context,timeout: 5),(e,trace){});
    }


  }
}
