
import 'package:hitop_cafe/models/user.dart';


class CustomerTools{

  /// search and sort the ware List
  static List<User> filterList(List<User> list,String? keyWord,String sort){

    if(keyWord!=null) {
      list =list.where((element){
        String lName=(element.lastName ?? "").toLowerCase().replaceAll(" ", "");
        String fName=element.name.toLowerCase().replaceAll(" ", "");
        String nName=(element.nickName ?? "").toLowerCase().replaceAll(" ", "");

        String key=keyWord.toLowerCase().replaceAll(" ", "");
        if((fName+lName).contains(key) || nName.contains(key)) {
          return true;
        }else {
          return false;
        }
      }).toList();
    }
      switch(sort){
        case "حروف الفبا":
          list.sort((a,b){
            return (a.lastName ?? "").compareTo(b.lastName ?? "");
          });
          break;
        case "امتیاز":
          list.sort((b,a){
            return (a.score ?? -1).compareTo(b.score ?? -1);
          });
          break;

        case "تاریخ ثبت" :
          list.sort((b,a){
            return a.createDate.compareTo(b.createDate);
          });
          break;
        case "تاریخ ویرایش" :
          list.sort((b,a){
            return a.modifiedDate.compareTo(b.modifiedDate);
          });
          break;

      }
      return list;


  }
}