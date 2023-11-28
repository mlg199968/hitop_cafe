import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/private.dart';
import 'package:hitop_cafe/models/subscription.dart';
import 'package:hitop_cafe/services/backend_services.dart';

import 'package:http/http.dart' as http;

class PayamitoApi {
  static Future<Map> sentMessage(BuildContext context, String phoneNumber) async {
    Random random = Random();
    String authCode = (random.nextInt(8998) + 1001).toString();
    var messageBox = {
      "username": PrivateKeys.payamitoUserName,
      "password": PrivateKeys.payamitoPass,
      "text": "$authCode;",
      "to": phoneNumber,
      "bodyId": "164658",
    };

    http.Response res = await http.post(
        Uri.parse(
            "https://rest.payamak-panel.com/api/SendSMS/BaseServiceNumber"),
        body: messageBox);
    print("statusCode");
    print(res.statusCode);
    if (res.statusCode == 200) {
      Map backData = jsonDecode(res.body);
      print("backData");
      print(backData);
      if (backData["RetStatus"] == 1 && context.mounted) {

        return {"isRight":true,"authCode":authCode};
      }else{
        return {"isRight":false,"authCode":null};
      }
    }else{
      return {"isRight":false,"authCode":null};
    }

  }
}
