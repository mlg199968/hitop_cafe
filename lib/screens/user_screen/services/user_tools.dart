

import 'package:hitop_cafe/constants/consts_class.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/user.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:provider/provider.dart';

class UserTools{

 static bool userPermission(context,{int? count,List? userTypes}){

   UserProvider userProvider=Provider.of<UserProvider>(context,listen: false);
    User? activeUser=Provider.of<UserProvider>(context,listen: false).activeUser;
    if(count==null || count < userProvider.ceilCount) {
      if(activeUser==null || userTypes==null || userTypes.contains(activeUser.userType) || activeUser.userType==UserType.admin) {
        return true;
      }
      //if app type is waiter app we don't have any limitation
      else if(userProvider.appType==AppType.waiter.value){
        return true;
      }
      else{
        showSnackBar(context, "شما اجازه دسترسی به این بخش را ندارید!",
            type: SnackType.error);
        return false;
      }
    }else{
      showSnackBar(context, userProvider.ceilCountMessage,
          type: SnackType.error);
    }
    return false;
  }
  /// search and sort the user List
  static List<User> filterList(
      List<User> list, String? keyWord, String sort) {

    if (keyWord != null && keyWord != "") {
      list = list.where((element) {
        String itemName = element.name.toLowerCase().replaceAll(" ", "");
        //String serial=element.serialNumber.toLowerCase().replaceAll(" ", "");
        String key = keyWord.toLowerCase().replaceAll(" ", "");
        if (itemName.contains(key)) {
          return true;
        } else {
          return false;
        }
      }).toList();
    }


    switch (sort) {

      case "حروف الفبا":
        list.sort((a, b) {

          return a.name.compareTo(b.name);
        });
        break;

      case "تاریخ ثبت":
        list.sort((b, a) {
          return a.createDate.compareTo(b.createDate);
        });
        break;
      case 'تاریخ ویرایش':
        list.sort((b, a) {
          return a.modifiedDate.compareTo(b.modifiedDate);
        });
        break;
    }
    return list;
  }
}