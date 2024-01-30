

import 'dart:math';

import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/models/pack.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';


class PackTools{

  ///get order Number
  static int getOrderNumber() {
    List<Order> orders=HiveBoxes.getOrders().values.toList();
    if(orders.isNotEmpty){
      int maxNum=orders.map((e) => e.billNumber ?? 0).cast<int>().reduce(max);
      return maxNum+1;
    }else{
      return 1;
    }
  }

  /// search and sort the order List
  static List<Pack> filterList(List<Pack> list,String? keyWord,String sort){

    if(keyWord!=null) {
      list= list.where((element){
        Order order=Order().fromJson(element.object!.single);
        String table=order.tableNumber.toString();
        String bill=order.billNumber.toString();

        String key=keyWord.toLowerCase().replaceAll(" ", "");
        if((table).contains(key) || (bill).contains(key) ) {
          return true;
        }else {
          return false;
        }
      }).toList();
    }
    switch(sort){
    // case "حروف الفبا":
    //   list.sort((a,b){
    //     return a.customer.lastName.compareTo(b.customer.lastName);
    //   });
    //   break;
      case "تاریخ ثبت" :
        list.sort((b,a){
          return _packToOrder(a).orderDate.compareTo(_packToOrder(b).orderDate);
        });
        break;
      case "تاریخ ویرایش" :
        list.sort((b,a){
          return _packToOrder(a).modifiedDate.compareTo(_packToOrder(b).modifiedDate);
        });
        break;
      case "شماره فاکتور":
        list.sort((b, a) {
          return (_packToOrder(a).billNumber ?? 0).compareTo(_packToOrder(b).billNumber ?? 0);
        });
        break;
      case "شماره میز":
        list.sort((b, a) {
          return (_packToOrder(a).tableNumber ?? 0).compareTo(_packToOrder(b).tableNumber ?? 0);
        });
        break;

      case "تاریخ تسویه" :
        list.sort((b,a){
          //because dueDate is can be null first we replace null dueDate with value
          DateTime a2= _packToOrder(a).dueDate ?? DateTime(1999);
          DateTime b2= _packToOrder(b).dueDate ?? DateTime(1999);
          return a2.compareTo(b2);
        });
        break;
    }
    return list;


  }

  static Order _packToOrder(Pack pack){
    return Order().fromJson(pack.object!.single);
  }
}