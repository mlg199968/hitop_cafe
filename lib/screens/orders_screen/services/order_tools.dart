

import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/models/order.dart';


class OrderTools{
///subtract ware when ware added to credit
  static void subtractFromWareStorage(List<Item> items,{Order? oldOrder}){
    // List<RawWare> wareList=HiveBoxes.getRawWare().values.toList();
    // //if user want to edit the existed bill,at first old bill ware quantity being add to storage in this line
    // if(oldOrder!=null){
    //   List<Item> oldPurchases=oldOrder.items;
    //   for(int i=0;i<wareList.length;i++){
    //     for(int j=0;j<oldPurchases.length;j++){
    //       if(oldPurchases[j].itemName==wareList[i].wareName){
    //         wareList[i].quantity+=oldPurchases[j].quantity;
    //       }
    //     }
    //   }
    // }
    // //find the item  in the ware storage then subtracted from storage quantity
    // for(int i=0;i<wareList.length;i++){
    //   for(int j=0;j<items.length;j++){
    //     if(items[j].wareName==wareList[i].wareName){
    //       wareList[i].quantity-=items[j].quantity;
    //       HiveBoxes.getWares().putAt(i, wareList[i]);
    //     }
    //   }
    // }
  }


/// search and sort the credit List
  static List<Order> filterList(List<Order> list,String? keyWord,String sort){

    if(keyWord!=null) {
      list= list.where((element){
        String table=element.tableNumber.toString();
        String id=element.orderId.toString();

        String key=keyWord.toLowerCase().replaceAll(" ", "");
        if((table).contains(key) || (id).contains(key) ) {
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

        case "تاریخ تسویه" :
          list.sort((b,a){
            //because dueDate is can be null first we replace null dueDate with value
            DateTime a2= a.dueDate==null ? a.dueDate=DateTime(1999):a.dueDate!;
            DateTime b2= b.dueDate==null ? b.dueDate=DateTime(1999):b.dueDate!;
            return a2.compareTo(b2);
          });
          //then after we compare dueDate ,we give the null value to the replaced dueDate
          list=list.where((element) {
            if (element.dueDate==DateTime(1999)){
              element.dueDate=null;
            }
            return true;
          }).toList();
          break;
      }
      return list;


  }
}