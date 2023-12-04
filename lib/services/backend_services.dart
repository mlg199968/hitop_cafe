import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/notice.dart';
import 'package:hitop_cafe/models/subscription.dart';
import 'package:http/http.dart' as http;


class BackendServices {
  Future<bool?> createSubscription(Subscription subs) async {
    try {

      http.Response res = await http.post(
          Uri.parse("$hostUrl/user/create_subscription.php"),
          body: subs.toMap());
      print(res.body);
      if (res.statusCode == 200) {
        print(res.body);
        var backData = jsonDecode(res.body);
        if (backData["success"] == true) {
          Fluttertoast.showToast(msg: "Subscription successfully saved");
          return true;
        } else {
          Fluttertoast.showToast(msg: "Subscription Not Saved!");
          return false;
        }
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Subscription?> readSubscription(context, String phone) async {
    try {
     String deviceId=await getDeviceInfo();
     print(deviceId);
      http.Response res = await http.post(
          Uri.parse("$hostUrl/user/read_subscription.php"),
          body: {"phone": phone,"device-id":deviceId});
      if (res.statusCode == 200) {
        print(res.body);
        var backData = jsonDecode(res.body);
        if (backData["success"] == true) {
            Subscription subs = Subscription().fromMap(backData["subsData"]);

            Fluttertoast.showToast(msg: "Subscription successfully being read!");
            return subs;

        } else {
          Fluttertoast.showToast(msg: "has not being purchase");
          return null;

        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }


  Future<List<Notice?>?> readNotice(context, String appName) async {
    try {

      http.Response res = await http.post(
          Uri.parse("$hostUrl/notification/read_notice.php"),
          body: {"app-name": appName});
      if (res.statusCode == 200) {
        print(res.body);
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
      debugPrint("error in backendServices.readNotice");
      debugPrint(e.toString());
    }
    return null;
  }



///get the options from mysql like the price of the app
  Future readOption(String optionName)async{
final res=await http.post(
    Uri.parse("$hostUrl/user/read_options.php"),
    body:{"option_name":optionName});
print(res.body);
if(res.statusCode==200){
  var backData=jsonDecode(res.body);
  if (backData["success"] == true){
    return backData["values"]["option_value"];
  }
}
  }

}
