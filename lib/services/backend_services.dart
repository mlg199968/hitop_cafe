import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/error_handler.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/notice.dart';
import 'package:hitop_cafe/models/server_models/device.dart';
import 'package:hitop_cafe/models/subscription.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:http/http.dart' as http;
import 'package:ntp/ntp.dart';
import 'package:provider/provider.dart';

class BackendServices {
  ///create new subscription data in host
  static Future<bool> createSubs(context,
      {required Subscription subs}) async {
    try {
      http.Response res =
          await http.post(Uri.parse("$hostUrl/user/create_subscription.php"),
              body: subs.toJson());
      if (res.statusCode == 200) {
        var backData = jsonDecode(res.body);

        if (backData["success"] == true) {
          showSnackBar(context, backData["message"] ?? "success",
              type: SnackType.success);
          return true;
        } else {
          showSnackBar(context, backData["message"] ?? "not success",
              type: SnackType.warning);
          if(backData["error"]!=null) {
            ErrorHandler.errorManger(null, backData["error"],
              title: backData["message"] ?? "backData success is false",);
          }
          return false;
        }
      }


    } catch (e) {
      ErrorHandler.errorManger(context, e,
          title: "BackendServices createSubs error");
    }
    return false;
  }

  ///read subscription data from host
  static Future<List<Subscription>?> readSubscription(
      context, String phone) async {
    try {
      Device device = await getDeviceInfo();

      http.Response res = await http
          .post(Uri.parse("$hostUrl/user/read_subscription2.php"),
          body: {
        "phone": phone,
        "device": device.toJson(),
        "app_name": kAppName,
      });
      if (res.statusCode == 200) {

        var backData = jsonDecode(res.body);
        if (backData["success"] == true) {
          List? subsMap=backData["subsData"];
          List<Subscription>? subsList = (subsMap == null || subsMap.isEmpty)
              ? null
              : (backData["subsData"] as List)
                  .map((e) => Subscription().fromMap(e))
                  .toList();
          debugPrint("Subscription successfully being read!");
          return subsList;
        } else if (backData["success"] == false) {
          debugPrint("has not being purchase");
          return null;
        } else {
          showSnackBar(context, "has not being read", type: SnackType.error);
          return null;
        }
      }
    } catch (e) {
      ErrorHandler.errorManger(context, e,
          title: "BackendServices-readSubscription error");
    }
    return null;
  }


  ///read Notifications from host
  Future<List<Notice?>?> readNotice(context,
      {String appName = kAppName, int timeout = 20}) async {
    try {
      http.Response res = await http.post(
          Uri.parse("$hostUrl/notification/read_notice.php"),
          body: {"app-name": appName}).timeout(Duration(seconds: timeout));
      if (res.statusCode == 200) {
        var backData = jsonDecode(res.body);
        if (backData["success"] == true) {
          List<Notice> notices = (backData["notification-list"] as List)
              .map((e) => Notice().fromJson(e["notice_object"]))
              .toList();

          debugPrint("notifications successfully being read!");
          return notices;
        } else {
          debugPrint("error in backendServices.readNotice php api error error");
          return null;
        }
      }
    } catch (e) {
      ErrorHandler.errorManger(null, e,
          title: "BackendServices-readSubscription error",);
    }
    return null;
  }

  ///get the options from mysql like the price of the app
  Future readOption(String optionName) async {
    final res = await http.post(Uri.parse("$hostUrl/user/read_options.php"),
        body: {"option_name": optionName});
    if (res.statusCode == 200) {
      var backData = jsonDecode(res.body);
      if (backData["success"] == true) {
        //return different value(price) for each platform
        if(Platform.isWindows){
          return backData["values"]["option_json"];
        }
        else{
          return backData["values"]["option_json2"] ?? backData["values"]["option_json"];
        }

      }
    }
  }
  ///fetch subscription
  Future<void> fetchSubscription(context) async{

    try {
      Subscription? storedSubs=HiveBoxes.getShopInfo().getAt(0)?.subscription;
      if(storedSubs!=null){
        List<Subscription>? readSubs =await readSubscription(context, storedSubs.phone);
        if (readSubs != null && readSubs.isNotEmpty) {
          for (Subscription subs in readSubs) {
            if(subs.device?.id==storedSubs.device?.id && subs.appName==kAppName){

              Provider.of<UserProvider>(context,listen:false)..setSubscription(subs)..setUserLevel(subs.level);
              await updateFetchDate(context, subs);
              break;
            }
            else{
              storedSubs.level=0;
              Provider.of<UserProvider>(context,listen:false)..setSubscription(storedSubs)..setUserLevel(subs.level);
            }
          }
        }
      }
    }catch(e) {
      ErrorHandler.errorManger(null, e,title: "BackendServices fetchSubscription function error");
    }
  }
  ///
  static Future<void> updateFetchDate(context ,Subscription subs) async{
    DateTime startDate = DateTime.now();
    try {
      //get online date with ntp package
      int offset =await NTP.getNtpOffset(lookUpAddress: 'time.cloudflare.com').timeout(const Duration(seconds: 5));
      print('NTP DateTime offset align: ${startDate.add(
          Duration(milliseconds: offset))}');
      //we save the date of this fetch
      subs.fetchDate = startDate.add(Duration(milliseconds: offset));
      subs.startDate ??= startDate.add(Duration(milliseconds: offset));

      BackendServices.createSubs(context, subs: subs).then((isCreated) {
        if (isCreated == true) {
          debugPrint("fetch date has been updated after fetch subscription");
        } else {
          debugPrint(
              "fetch date has not been updated after fetch subscription");
        }
      });
    }catch(e){
      subs.fetchDate = startDate;
      subs.startDate ??= startDate;
      ErrorHandler.errorManger(null, e,title: "backendServices updateFetchDate error");
    }
  }

}
