import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/error_handler.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/FetchdataRequestEntity.dart';
import 'package:hitop_cafe/models/SubscriptionResponseEntity.dart';
import 'package:hitop_cafe/models/notice.dart';
import 'package:hitop_cafe/models/onlinedatamodel.dart';
import 'package:hitop_cafe/models/subRequest.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/services/HttpUtil.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


class BackendServices {



  static Future<dynamic>? createSubs({SubscriptionData? params}) async {
    try {
      var response = await HttpUtil().post('/user/create_subscription.php/',
          queryParameters: params!.toJson());
      print(response.toString());
      // Assuming responseString is the JSON string you received from the server
      Map<String, dynamic> jsonResponse = json.decode(response);
      print(jsonResponse.toString());

// Check if the request was successful
      if (jsonResponse["success"] == true) {
        // Access other properties if needed
        // Example: String message = jsonResponse["message"];
        // Example: dynamic subsData = jsonResponse["subsData"];
        return SubscriptionResponseEntity.fromJson(jsonResponse);
      } else {
        // Handle the case where the request was not successful
        String errorMessage = jsonResponse["message"];
        print("Error: $errorMessage");
        return ErrorResponse.fromJson(jsonResponse);
      }

      // if (response['success']) {
      //   return SubscriptionResponseEntity.fromJson(response);
      // } else {
      //   return ErrorResponse.fromJson(response);
      // }
    } catch (e) {
      print('Error: $e');
      // Handle network or other errors as needed
      return null;
    }
  }

  static Future<dynamic>? fetchDataList(
      // {String? phone, Map<String, dynamic>? deviceId}) async {
          {FetchdataRequestEntity? params}) async {
    try {
      var response = await HttpUtil().get('db/user/read_subscription.php/',
          queryParameters: params?.toJson());
      print(response.toString());

      Map<String, dynamic> jsonResponse = json.decode(response);

      if (jsonResponse["success"] == true) {
        // Access other properties if needed
        return DatalistModel.fromJson(jsonResponse);
      } else {
        // Handle the case where the request was not successful
        String errorMessage = jsonResponse["message"];
        print("Error: $errorMessage");
        return ErrorResponse.fromJson(jsonResponse);
      }
    } catch (e) {
      print('Error: $e');
      // Handle network or other errors as needed
      return null;
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

  Future<void> fetchData(BuildContext context) async {
    Map<String, dynamic>? deviceId = await getDeviceInfo();
    Map<String, dynamic>? searchParams = deviceId;
    debugPrint("dynamic data READ$searchParams");

    Map<String, dynamic> requestData = {
      'deviceId': searchParams,
      // 'phone': value,
    };
    debugPrint("here is data for READ $requestData");
    String url = 'https://mlggrand.ir/db/user/read_subscription.php?'
        'id=${searchParams?['id']}&brand=${searchParams?['brand']}&platform=${searchParams?['platform']}';
    debugPrint("URL$url");
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
          Provider.of<UserProvider>(context, listen: false).setLevel(level!);
        } else {
          Provider.of<UserProvider>(context, listen: false).setLevel(level!);
        }
      } else {
        Map<String, dynamic>? deviceId = await getDeviceInfo();
        Map<String, dynamic>? dynamicData = deviceId;
        // Other string data
        final platform = deviceId?["platform"].toString();
        final level = UserProvider().level;
        Map<String, dynamic> requestData = {
          'deviceId': dynamicData,
          'level': level,
          'platform': platform,
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
