import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/models/shop.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/providers/ware_provider.dart';
import 'package:hitop_cafe/screens/side_bar/notice_screen/services/notice_tools.dart';
import 'package:hitop_cafe/services/backend_services.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:hitop_cafe/services/storage_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class GlobalTask {
  static final GlobalKey<NavigatorState> navigatorState = GlobalKey<NavigatorState>();
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
    }
    else{
      HiveBoxes.getShopInfo().add(shop);
    }
    ///get app version
   final deviceInfo=await PackageInfo.fromPlatform();
    Provider.of<UserProvider>(context, listen: false).setAppVersion(deviceInfo.version);
    ///
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.ethernet ||
        connectivityResult == ConnectivityResult.vpn) {

      /// fetch subscription data
      if(Provider.of<UserProvider>(context, listen: false).appType!=AppType.waiter.value) {
        BackendServices().fetchSubs(navigatorState.currentContext);
      }
      ///get notifications
      runZonedGuarded(() => NoticeTools.readNotifications(navigatorState.currentContext,timeout: 5),(e,trace){});
    }
  }
}
