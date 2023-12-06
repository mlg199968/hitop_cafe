import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/error_handler.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/notice.dart';
import 'package:hitop_cafe/models/subscription.dart';
import 'package:http/http.dart' as http;


class BackendServices {
  ///create new subscription data in host
  Future<bool?> createSubscription(context,Subscription subs) async {
    try {

      http.Response res = await http.post(
          Uri.parse("$hostUrl/user/create_subscription.php"),
          body: subs.toMap());
      print(res.body);
      if (res.statusCode == 200) {
        print(res.body);
        var backData = jsonDecode(res.body);
        if (backData["success"] == true) {
          showSnackBar(context,"Subscription successfully saved",type: SnackType.success);
          return true;
        } else {
          showSnackBar(context,"Subscription Not Saved!",type: SnackType.warning);
          return false;
        }
      }
    } catch (e) {
      ErrorHandler.errorManger(context, e,title: "BackendServices-createSubscription error",showSnackbar: true);
    }
    return null;
  }
///read subscription data from host
  Future<Subscription?> readSubscription(context, String phone) async {
    try {
     String deviceId=await getDeviceInfo();
      http.Response res = await http.post(
          Uri.parse("$hostUrl/user/read_subscription.php"),
          body: {"phone": phone,"device-id":deviceId});
      if (res.statusCode == 200) {
        var backData = jsonDecode(res.body);
        if (backData["success"] == true) {
            Subscription subs = Subscription().fromMap(backData["subsData"]);
            showSnackBar(context,"Subscription successfully being read!",type: SnackType.success);
            return subs;

        } else {
          showSnackBar(context,"has not being purchase",type: SnackType.warning);
          return null;

        }
      }
    } catch (e) {
      ErrorHandler.errorManger(context, e,title: "BackendServices-readSubscription error",showSnackbar: true);
    }
    return null;
  }

///read Notifications from host
  Future<List<Notice?>?> readNotice(context, String appName) async {
    try {

      http.Response res = await http.post(
          Uri.parse("$hostUrl/notification/read_notice.php"),
          body: {"app-name": appName});
      if (res.statusCode == 200) {
        var backData = jsonDecode(res.body);
        if (backData["success"] == true) {
          List<Notice> notices =(backData["notification-list"] as List).map((e) => Notice().fromJson(e["notice_object"])).toList() ;

          debugPrint("notifications successfully being read!");
          return notices;

        } else {
          debugPrint("error in backendServices.readNotice php api error error");
          return null;

        }
      }
    } catch (e) {
      ErrorHandler.errorManger(context, e,title: "BackendServices-readSubscription error",showSnackbar: true);
    }
    return null;
  }



///get the options from mysql like the price of the app
  Future readOption(String optionName)async{
final res=await http.post(
    Uri.parse("$hostUrl/user/read_options.php"),
    body:{"option_name":optionName});
if(res.statusCode==200){
  var backData=jsonDecode(res.body);
  if (backData["success"] == true){
    return backData["values"]["option_value"];
  }
}
  }

}
