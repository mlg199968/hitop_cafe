

import 'package:flutter/material.dart';
import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/models/raw_ware.dart';
import 'package:hitop_cafe/models/bill.dart';
import 'package:hitop_cafe/screens/home_screen/home_screen.dart';
import 'package:hitop_cafe/screens/items_screen/add_item_screen.dart';
import 'package:hitop_cafe/screens/items_screen/items_screen.dart';
import 'package:hitop_cafe/screens/orders_screen/add_order_screen.dart';
import 'package:hitop_cafe/screens/orders_screen/order_screen.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/add_raw_ware_screen.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/raw_ware_screen.dart';
import 'package:hitop_cafe/screens/shopping-bill/add-shopping-bill-screen.dart';
import 'package:hitop_cafe/screens/shopping-bill/shoping-bill-screen.dart';


import 'package:hitop_cafe/screens/ware_house/ware_house_screen.dart';

Route generateRoute(RouteSettings routeSetting){
  switch(routeSetting.name){
    case HomeScreen.id:
      return MaterialPageRoute(builder: (_)=>const HomeScreen());
    case OrderScreen.id:
      return MaterialPageRoute(builder: (_)=>const OrderScreen());

   case AddOrderScreen.id:
     Order? order=routeSetting.arguments as Order?;
        return MaterialPageRoute(builder: (_)=> AddOrderScreen(oldOrder: order,));

    case AddShoppingBillScreen.id:
     Bill? bill=routeSetting.arguments as Bill?;
        return MaterialPageRoute(builder: (_)=> AddShoppingBillScreen(oldBill: bill,));

   case WareHouseScreen.id:
        return MaterialPageRoute(builder: (_)=>const WareHouseScreen());

   case ShoppingBillScreen.id:
     Key? key = routeSetting.arguments as Key?;
        return MaterialPageRoute(builder: (_)=> ShoppingBillScreen(key: key));

   case WareListScreen.id:
     Key? key = routeSetting.arguments as Key?;
        return MaterialPageRoute(builder: (_)=> WareListScreen(key: key));

   case ItemsScreen.id:
     Key? key = routeSetting.arguments as Key?;
        return MaterialPageRoute(builder: (_)=> ItemsScreen(key: key));
 case AddItemScreen.id:
   Item? item=routeSetting.arguments as Item?;
        return MaterialPageRoute(builder: (_)=> AddItemScreen(oldItem:item ));

  case AddWareScreen.id:
    RawWare? rawWare = routeSetting.arguments as RawWare?;
        return MaterialPageRoute(builder: (_)=> AddWareScreen(oldRawWare: rawWare));



    default:
      return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('the Screen is not exist.'),
            ),
          ));
  }
}