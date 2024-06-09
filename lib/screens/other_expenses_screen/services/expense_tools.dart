
import 'package:hitop_cafe/models/payment.dart';


class ExpenseTools{

  /// search and sort the bill List
  static List<Payment> filterList(List<Payment> list,String? keyWord,String sort){
    if(keyWord != null) {
      list= list.where((element){
        String key=keyWord.toLowerCase().replaceAll(" ", "");
        String des=element.description.toString().toLowerCase().replaceAll(" ", "");
        String amount=element.amount.toString().toLowerCase().replaceAll(" ", "");
        if(amount.contains(key) ||des.contains(key) ) {
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
      case "تاریخ ثبت" :
        list.sort((b,a){
          return a.deliveryDate.compareTo(b.deliveryDate);
        });
    }

    return list;


  }
}