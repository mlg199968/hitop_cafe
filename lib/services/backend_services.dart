import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/error_handler.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/notice.dart';
import 'package:hitop_cafe/models/plan.dart';
import 'package:hitop_cafe/models/server_models/device.dart';
import 'package:hitop_cafe/models/subscription.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:http/http.dart' as http;
import 'package:ntp/ntp.dart';
import 'package:provider/provider.dart';

class BackendServices {
  ///create new subscription data in host
  static Future<String?> createSubs(context, {required Subscription subs}) async {
    try {
      http.Response res = await http.post(
          Uri.parse("$hostUrl/user/create_subscription.php"),
          body: subs.toJson());
      if (res.statusCode == 200) {
        var backData = jsonDecode(res.body);
        if (backData["success"] == true) {
          showSnackBar(context, backData["message"] ?? "success",
              type: SnackType.success);
          return backData["id"].toString();
        } else {
          showSnackBar(context, backData["message"] ?? "not success",
              type: SnackType.warning);
          if (backData["error"] != null) {
            ErrorHandler.errorManger(
              null,
              backData["error"],
              title: backData["message"] ?? "backData success is false",
            );
          }
          return null;
        }
      }
    } catch (e,stacktrace) {
      ErrorHandler.errorManger(context, e,
          stacktrace: stacktrace,
          title: "BackendServices createSubs error");
    }
    return null;
  }

  ///read subscription data from host
  static Future<Map> readSubscription(
      context, String phone,{String? subsId}) async {
    Map map={"success":false,"subs":null};
    try {
      Device device = await getDeviceInfo();
      http.Response res = await http
          .post(Uri.parse("$hostUrl/user/read_subscription.php"), body: {
        "phone": phone,
        "device": device.toJson(),
        "appName": kAppName,
        "subsId": subsId,
      });
      print(res.body);
      if (res.statusCode == 200) {
        var backData = jsonDecode(res.body);
        if (backData["success"] == true) {
          map["success"]=true;
          map["subs"]=backData["subsData"]==null?null:Subscription().fromMap(backData["subsData"]);
          debugPrint("Subscription successfully being read!");
          return map;
        }
        else {
          showSnackBar(context, "has not being read", type: SnackType.error);
          return map;
        }
      }
    } catch (e,stacktrace) {
      ErrorHandler.errorManger(context, e,
          stacktrace: stacktrace,
          title: "BackendServices-readSubscription error");
    }
    return map;
  }

  ///read Notifications from host
  Future<List<Notice?>?> readNotice(context,
      {String appName = kAppName, int timeout = 20}) async {
    try {
      http.Response res = await http.post(
          Uri.parse("$hostUrl/notification/read_notice.php"),
          body: {
            "app-name": appName,
            "platform": Platform.executable,
            "version":Provider.of<UserProvider>(context, listen: false).appVersion,
          },
      ).timeout(Duration(seconds: timeout));
      if (res.statusCode == 200) {
        // print(res.body);
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
    } catch (e,stacktrace) {
      ErrorHandler.errorManger(
        null,
        e,
        stacktrace:stacktrace,
        title: "BackendServices-readSubscription error",
      );
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
        if (Platform.isWindows) {
          return backData["values"]["option_json"];
        } else {
          return backData["values"]["option_json2"] ??
              backData["values"]["option_json"];
        }
      }
    }
  }
  ///read purchase plan
  Future<List<Plan>?> readPlans() async {
    try {
      Device device = await getDeviceInfo();
      final res = await http.post(Uri.parse("$hostUrl/payment/read_plans.php"),
          body: {"appName": kAppName, "platform": device.platform});
      if (res.statusCode == 200) {
        var backData = jsonDecode(res.body);
        if (backData["success"] == true) {
          List<Plan> planList = (backData["plans"] as List).map((e) =>
              Plan().fromMap(e)).toList();
          return planList;
        }else{
          ErrorHandler.errorManger(
            null,
            null,
            errorText:backData["message"] ,
            stacktrace:backData["error"],
            title: "BackendServices-readPlans error",
          );
        }
      }
    }catch(e,stacktrace){
      ErrorHandler.errorManger(
        null,
        e,
        stacktrace:stacktrace,
        title: "BackendServices-readPlans error",
      );
    }
    return null;
  }

  ///fetch subscription
  Future<void> fetchSubscription(context) async {
    try {
      Subscription? storedSubs = HiveBoxes.getShopInfo().getAt(0)?.subscription;
      if (storedSubs != null) {
        Map readSubs =
            await readSubscription(context, storedSubs.phone,subsId: storedSubs.id.toString());
        if (readSubs["success"]==true) {
              Provider.of<UserProvider>(context, listen: false)
                ..setSubscription(readSubs["subs"])
                ..setUserLevel(readSubs["subs"]?.level ?? 0);
              if(readSubs["subs"]!=null) {
                await updateFetchDate(context, readSubs["subs"]);
              }
        }
      }
    } catch (e,stacktrace) {
      ErrorHandler.errorManger(null, e,
          stacktrace: stacktrace,
          title: "BackendServices fetchSubscription function error");
    }
  }

  ///
  static Future<void> updateFetchDate(context, Subscription subs) async {
    DateTime startDate = DateTime.now();
    try {
      //get online date with ntp package
      int offset = await NTP
          .getNtpOffset(lookUpAddress: 'time.cloudflare.com')
          .timeout(const Duration(seconds: 5));
      print(
          'NTP DateTime offset align: ${startDate.add(Duration(milliseconds: offset))}');
      //we save the date of this fetch
      subs.fetchDate = startDate.add(Duration(milliseconds: offset));
      subs.startDate ??= startDate.add(Duration(milliseconds: offset));

      BackendServices.createSubs(context, subs: subs).then((isCreated) {
        if (isCreated != null) {
          debugPrint("fetch date has been updated after fetch subscription");
        } else {
          debugPrint(
              "fetch date has not been updated after fetch subscription");
        }
      });
    } catch (e) {
      subs.fetchDate = startDate;
      subs.startDate ??= startDate;
      ErrorHandler.errorManger(null, e,
          title: "backendServices updateFetchDate error");
    }
  }
  ///get server time
  static Future<DateTime> getServerTime() async {
    try {
      final res = await http.get(Uri.parse("$hostUrl/time.php"));
      if (res.statusCode == 200) {
        var backData = jsonDecode(res.body);
        if (backData["success"]==true) {
            return DateTime.parse(backData["time"]);
        }else{
          ErrorHandler.errorManger(null, backData["error"],
              title: "backendServices getServerTime  time.php error");
          return DateTime.now();

        }
      }else{
        ErrorHandler.errorManger(null, res.statusCode,
            title: "backendServices getServerTime connection to time.php error");
        return DateTime.now();
      }
    } catch (e,stacktrace) {
      ErrorHandler.errorManger(null, e,
          route: stacktrace.toString(),
          title: "backendServices getServerTime error");
      return DateTime.now();
    }
  }
}
