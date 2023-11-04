

import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/models/raw_ware.dart';
import 'package:hitop_cafe/models/bill.dart';
import 'package:hitop_cafe/models/shop.dart';
import 'package:hive/hive.dart';

class HiveBoxes{

  static Box<RawWare> getRawWare(){
    return Hive.box<RawWare>("ware_db");
  }

  static Box<Item> getItem(){
    return Hive.box<Item>("item_db");
  }

 static Box<Order> getOrders(){
    return Hive.box<Order>("order_db");
  }

static Box<Bill> getBills(){
    return Hive.box<Bill>("bill_db");
  }

static Box<Shop> getShopInfo(){
    return Hive.box<Shop>("shop_db");
  }


  static List getRawWareCategories(){
    final categories= Hive.box<RawWare>("ware_db").values.map((ware) => ware.category).toSet().toList();
    return categories;
  }
 static List getItemCategories(){
    final categories= Hive.box<Item>("item_db").values.map((item) => item.category).toSet().toList();
    return categories;
  }





}