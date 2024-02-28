import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/error_handler.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/notice.dart';
import 'package:hitop_cafe/models/server_models/device.dart';
import 'package:hitop_cafe/models/subscription.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/services/HttpUtil.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


class BackendServices {


  ///create new subscription data in host
  static Future<dynamic>? createSubs(context,{required Subscription subs}) async {
    try {
      http.Response res = await http.post(
                Uri.parse("$hostUrl/user/create_subscription.php"),
          headers: {
                  'Content-Type': 'application/json',
            },
                body: subs.toJson());
            if (res.statusCode == 200) {
              print(res.body);
              var backData = jsonDecode(res.body);

              if (backData["success"]==true) {
                showSnackBar(context,"Subscription successfully saved",type: SnackType.success);
                print("backData[message]********");
                print(backData["message"]);
                return true;
              } else {
                showSnackBar(context,"Subscription Not Saved!",type: SnackType.warning);
                return false;
              }
            }
    } catch (e) {
      ErrorHandler.errorManger(context, e,title: "BackendServices createSubs error",showSnackbar: true);
    }
  }

  ///create new subscription data in host
  // Future<bool?> createSubscription(context,Subscription subs) async {
  //   try {
  //
  //     http.Response res = await http.post(
  //         Uri.parse("$hostUrl/user/create_subscription.php"),
  //         body: subs.toMap());
  //     print(res.body);
  //     if (res.statusCode == 200) {
  //       print(res.body);
  //       var backData = jsonDecode(res.body);
  //
  //       if (backData["success"] == true) {
  //         showSnackBar(context,"Subscription successfully saved",type: SnackType.success);
  //         return true;
  //       } else {
  //         showSnackBar(context,"Subscription Not Saved!",type: SnackType.warning);
  //         return false;
  //       }
  //     }
  //   } catch (e) {
  //     ErrorHandler.errorManger(context, e,title: "BackendServices-createSubscription error",showSnackbar: true);
  //   }
  //   return null;
  // }
  ///read subscription data from host
  static Future<Subscription?> readSubscription(context, String phone) async {
    try {
     Device device=await getDeviceInfo();
      http.Response res = await http.post(
          Uri.parse("$hostUrl/user/read_subscription.php?id=${device.id}&brand=${device.brand}&platform=${device.platform}&phone=$phone"),
          headers: {'Content-Type': 'application/json'},
         // body: {"phone": phone,"device-id":device.toJson()}
      );
      if (res.statusCode == 200) {
        var backData = jsonDecode(res.body);
        if (backData["success"] == true) {
            Subscription subs = Subscription().fromMap(backData["subsData"]);
            showSnackBar(context,"Subscription successfully being read!",type: SnackType.success);
            return subs;

        } else if(backData["success"] == false){
          showSnackBar(context,"has not being purchase",type: SnackType.warning);
          return null;

        } else{
          showSnackBar(context,"has not being read",type: SnackType.error);
          return null;
        }
      }
    } catch (e) {
      ErrorHandler.errorManger(context, e,title: "BackendServices-readSubscription error",showSnackbar: true);
    }
    return null;
  }
//   Future<Subscription?> readSubscription(context, String phone) async {
//     try {
//      String deviceId=await getDeviceInfo();
//       http.Response res = await http.post(
//           Uri.parse("$hostUrl/user/read_subscription.php"),
//           body: {"phone": phone,"device-id":deviceId});
//       if (res.statusCode == 200) {
//         var backData = jsonDecode(res.body);
//         if (backData["success"] == true) {
//             Subscription subs = Subscription().fromMap(backData["subsData"]);
//             showSnackBar(context,"Subscription successfully being read!",type: SnackType.success);
//             return subs;
//
//         } else {
//           showSnackBar(context,"has not being purchase",type: SnackType.warning);
//           return null;
//
//         }
//       }
//     } catch (e) {
//       ErrorHandler.errorManger(context, e,title: "BackendServices-readSubscription error",showSnackbar: true);
//     }
//     return null;
//   }

  ///read Notifications from host
  Future<List<Notice?>?> readNotice(context, {String appName=kAppName,int timeout=20}) async {
    try {

      http.Response res = await http.post(
          Uri.parse("$hostUrl/notification/read_notice.php"),
          body: {"app-name":appName}).timeout(Duration(seconds:timeout ));
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
///
  Future<void> fetchData(BuildContext context) async {
    Device device = await getDeviceInfo();

    String url = 'https://mlggrand.ir/db/user/read_subscription.php?'
        'id=${device.id}&brand=${device.brand}&platform=${device.platform}';

    // Make the GET request with the combined URL
    var response = await HttpUtil().get(
      url,
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    debugPrint("RESPONSER HERER IIIII${response.toString()}");
    var jsonResponse = json.decode(response);
    if (context.mounted) {
      debugPrint(jsonResponse.toString());
      debugPrint(jsonResponse['subsData'].toString());
      if (jsonResponse['success']) {
        final level = jsonResponse['subsData']['level'];
        debugPrint("LEVEL{$level}");
        if (level != null && level != 0) {
          Provider.of<UserProvider>(context, listen: false).setUserLevel(level!);
        } else {
          Provider.of<UserProvider>(context, listen: false).setUserLevel(level!);
        }
      } else {
        Device device = await getDeviceInfo();
        final level = UserProvider().userLevel;
        Map<String, dynamic> requestData = {
          'deviceId': device.toMap(),
          'level': level,
          'platform': device.platform,
        };
        debugPrint("here is data for create $requestData");
        // Convert the map to JSON
        String jsonData = jsonEncode(requestData);
        //
        debugPrint("STRING$jsonData");
        // Make the POST request
        var response = await HttpUtil().post(
          'https://mlggrand.ir/db/user/create_subscription.php',
          data: jsonData,
          options: Options(headers: {'Content-Type': 'application/json'}),
        );
        print("responseData$response");
        var responseData = response["success"];
        print("responseData$responseData");
        print('Failure message: ${jsonResponse["message"]}');
      }
    }
  }
}
