import 'package:flutter/material.dart';
import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/models/raw_ware.dart';
import 'package:hitop_cafe/models/bill.dart';
import 'package:hitop_cafe/screens/analytics/analytics_screen.dart';
import 'package:hitop_cafe/screens/home_screen/home_screen.dart';
import 'package:hitop_cafe/screens/items_screen/add_item_screen.dart';
import 'package:hitop_cafe/screens/items_screen/items_screen.dart';
import 'package:hitop_cafe/screens/orders_screen/add_order_screen.dart';
import 'package:hitop_cafe/screens/orders_screen/order_screen.dart';
import 'package:hitop_cafe/screens/orders_screen/quick_add_screen.dart';
import 'package:hitop_cafe/screens/present_orders/present_order_screen.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/add_raw_ware_screen.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/raw_ware_screen.dart';
import 'package:hitop_cafe/screens/shopping-bill/add-shopping-bill-screen.dart';
import 'package:hitop_cafe/screens/shopping-bill/shopping-bill-screen.dart';
import 'package:hitop_cafe/screens/side_bar/bug_screen/bug_list_screen.dart';
import 'package:hitop_cafe/screens/side_bar/notice_screen/notice_screen.dart';
import 'package:hitop_cafe/screens/side_bar/purchase_app/authority_screen.dart';
import 'package:hitop_cafe/screens/side_bar/purchase_app/purchase_app_screen.dart';
import 'package:hitop_cafe/screens/side_bar/setting/print_screen.dart';
import 'package:hitop_cafe/screens/side_bar/setting/setting_screen.dart';
import 'package:hitop_cafe/screens/side_bar/shop_info/shop_info_screen.dart';
import 'package:hitop_cafe/screens/splash_screen/splash_screen.dart';

import 'package:hitop_cafe/screens/ware_house/ware_house_screen.dart';

Route generateRoute(RouteSettings routeSetting) {
  switch (routeSetting.name) {

    case SplashScreen.id:
      return MaterialPageRoute(builder: (_) =>  const SplashScreen());

    case HomeScreen.id:
      return MaterialPageRoute(builder: (_) => const HomeScreen());

    case OrderScreen.id:
      return MaterialPageRoute(builder: (_) => const OrderScreen());

    case PresentOrderScreen.id:
      return MaterialPageRoute(builder: (_) => const PresentOrderScreen());

    case AddOrderScreen.id:
      Order? order = routeSetting.arguments as Order?;
      return MaterialPageRoute(
          builder: (_) => AddOrderScreen(
                oldOrder: order,
              ));

    case QuickAddScreen.id:
      return MaterialPageRoute(
          builder: (_) => const QuickAddScreen());

    case AddShoppingBillScreen.id:
      Bill? bill = routeSetting.arguments as Bill?;
      return MaterialPageRoute(
          builder: (_) => AddShoppingBillScreen(
                oldBill: bill,
              ));

    case WareHouseScreen.id:
      return MaterialPageRoute(builder: (_) => const WareHouseScreen());

    case ShoppingBillScreen.id:
      Key? key = routeSetting.arguments as Key?;
      return MaterialPageRoute(builder: (_) => ShoppingBillScreen(key: key));

    case WareListScreen.id:
      Key? key = routeSetting.arguments as Key?;
      return MaterialPageRoute(builder: (_) => WareListScreen(key: key));

    case ItemsScreen.id:
      Key? key = routeSetting.arguments as Key?;
      return MaterialPageRoute(builder: (_) => ItemsScreen(key: key));

    case AddItemScreen.id:
      Item? item = routeSetting.arguments as Item?;
      return MaterialPageRoute(builder: (_) => AddItemScreen(oldItem: item));

    case AddWareScreen.id:
      RawWare? rawWare = routeSetting.arguments as RawWare?;
      return MaterialPageRoute(
          builder: (_) => AddWareScreen(oldRawWare: rawWare));

    case ShopInfoScreen.id:
      return MaterialPageRoute(builder: (_) => const ShopInfoScreen());

    case SettingScreen.id:
      return MaterialPageRoute(builder: (_) => const SettingScreen());

    case AnalyticsScreen.id:
      return MaterialPageRoute(builder: (_) => const AnalyticsScreen());

    case NoticeScreen.id:
      return MaterialPageRoute(builder: (_) => const NoticeScreen());

    case BugListScreen.id:
      return MaterialPageRoute(builder: (_) => const BugListScreen());


    case PurchaseAppScreen.id:
      Map? args = routeSetting.arguments as Map?;
      return MaterialPageRoute(builder: (_) => PurchaseAppScreen(phone: args?["phone"],level: args?["level"],));

    case AuthorityScreen.id:
      return MaterialPageRoute(builder: (_) =>  const AuthorityScreen());

    case PrinterPage.id:
      Key? key = routeSetting.arguments as Key?;
      return MaterialPageRoute(builder: (_) => PrinterPage(key: key));

    default:
      return MaterialPageRoute(
          builder: (_) => const Scaffold(
                body: Center(
                  child: Text('the Screen is not exist.'),
                ),
              ));
  }
}
