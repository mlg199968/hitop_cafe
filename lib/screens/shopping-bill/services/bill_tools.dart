

import 'dart:math';

import 'package:hitop_cafe/models/purchase.dart';
import 'package:hitop_cafe/models/raw_ware.dart';
import 'package:hitop_cafe/models/bill.dart';

import '../../../services/hive_boxes.dart';

class BillTools{
///subtract ware from storage when ware has been added to bill
  static void addToWareStorage(List<Purchase> purchases,{Bill? oldBill}){

    List<RawWare> wareList=HiveBoxes.getRawWare().values.toList();
    //if user want to edit the existed bill,at first old bill ware quantity being add to storage in this line
    if(oldBill!=null){
      List<Purchase> oldWares=oldBill.purchases;
      for(int i=0;i<wareList.length;i++){
        for(int j=0;j<oldWares.length;j++){
          if(oldWares[j].wareName==wareList[i].wareName){
            wareList[i].quantity-=oldWares[j].quantity;
          }
        }
      }
    }
    //find the purchase  in the ware storage then subtracted from storage quantity
    for(int i=0;i<wareList.length;i++){
      for(int j=0;j<purchases.length;j++){
        if(purchases[j].wareName==wareList[i].wareName){
          print( wareList[i].quantity);
          wareList[i].quantity+=purchases[j].quantity;
          print("بعد از افزودن");
          print( wareList[i].quantity);
          HiveBoxes.getRawWare().putAt(i, wareList[i]);
        }
      }
    }

  }

  ///bill number finder
  static int getBillNumber() {
    List<Bill> orders=HiveBoxes.getBills().values.toList();
    if(orders.isNotEmpty){
      int maxNum=orders.map((e) => e.billNumber).cast<int>().reduce(max);
      return maxNum+1;
    }else{
      return 1;
    }
  }


  /// search and sort the bill List
  static List<Bill> filterList(List<Bill> list,String? keyWord,String sort){
    if(keyWord != null) {
      list= list.where((element){
        String key=keyWord.toLowerCase().replaceAll(" ", "");
        if(element.billNumber.toString().contains(key)) {
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
        // break;
          case "شماره فاکتور":
          list.sort((b,a){
            return a.billNumber.compareTo(b.billNumber);
          });
          break;

        case "تاریخ ثبت" :
          list.sort((b,a){
            return a.billDate.compareTo(b.billDate);
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