

import 'dart:math';

import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/models/raw_ware.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';


class OrderTools{
///subtract ware when ware added to credit
  static void subtractFromWareStorage(List<Item> items,{Order? oldOrder}){
    List<RawWare> wareList=HiveBoxes.getRawWare().values.toList();
    //if user want to edit the existed bill,at first old bill ware quantity being add to storage in this line
    if(oldOrder!=null){
      List<Item> oldItems=oldOrder.items;
      for(int i=0;i<wareList.length;i++){
        for(int j=0;j<oldItems.length;j++){
          List<RawWare> oldWares=oldItems[j].ingredients;
          for(int k=0;k<oldWares.length;k++) {
            if (oldWares[k].wareId == wareList[i].wareId) {
              wareList[i].quantity += oldWares[k].demand * (oldItems[j].quantity ?? 1);
            }
          }
        }
      }
    }
    //find the item  in the ware storage then subtracted from storage quantity
    for(int i=0;i<wareList.length;i++){
      for(int j=0;j<items.length;j++){
        List<RawWare> wares=items[j].ingredients;
        for(int k=0;k<wares.length;k++) {
          if (wares[k].wareId == wareList[i].wareId) {
            wareList[i].quantity -= wares[k].demand*(items[j].quantity ?? 1);
            HiveBoxes.getRawWare().putAt(i, wareList[i]);
          }
        }
      }
    }
  }

  ///get tableNumber
 static int getOrderNumber() {
List<Order> orders=HiveBoxes.getOrders().values.toList();
if(orders.isNotEmpty){
  int maxNum=orders.map((e) => e.billNumber ?? 0).cast<int>().reduce(max);
  return maxNum+1;
}else{
 return 1;
}
  }

/// search and sort the credit List
  static List<Order> filterList(List<Order> list,String? keyWord,String sort){

    if(keyWord!=null) {
      list= list.where((element){
        String table=element.tableNumber.toString();
        String bill=element.billNumber.toString();

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
            return a.orderDate.compareTo(b.orderDate);
          });
          break;
        case "تاریخ ویرایش" :
          list.sort((b,a){
            return a.modifiedDate.compareTo(b.modifiedDate);
          });
          break;
        case "شماره فاکتور":
          list.sort((b, a) {
            return (a.billNumber ?? 0).compareTo(b.billNumber ?? 0);
          });
          break;
       case "شماره میز":
          list.sort((b, a) {
            return (a.tableNumber ?? 0).compareTo(b.tableNumber ?? 0);
          });
          break;

        case "تاریخ تسویه" :
          list.sort((b,a){
            //because dueDate is can be null first we replace null dueDate with value
            DateTime a2= a.dueDate ?? DateTime(1999);
            DateTime b2= b.dueDate ?? DateTime(1999);
            return a2.compareTo(b2);
          });
          break;
      }
      return list;


  }
}