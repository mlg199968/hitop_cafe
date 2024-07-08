import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/error_handler.dart';
import 'package:hitop_cafe/constants/private.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/server_models/device.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zarinpal/zarinpal.dart';
import 'package:http/http.dart' as http;

class ZarinpalApi {
  static payment(BuildContext context,
      {required String phone,
      required String planId,
      required String subsId,
      required int amount}) async {
    Device device = await getDeviceInfo();
    PaymentRequest paymentRequest = PaymentRequest()
      ..setIsSandBox(false)
      ..setAmount(amount)
      ..setDescription(device.toJson())
      ..setMerchantID(PrivateKeys.zarinpalId)
      ..setCallbackURL(
          "https://mlggrand.ir/db/payment/payzarin.php?phone=$phone&amount=$amount&planId=$planId&subsId=$subsId&appName=$kAppName&deviceId=${device.toJson()}");

    ZarinPal().startPayment(paymentRequest, (status, paymentGatewayUri) {
      try {
        if (status == 100) {
          launchUrl(Uri.parse(paymentGatewayUri!),
              mode: LaunchMode.externalApplication);
        } else {
          showSnackBar(context, "error $status on the ZarinPalApi.payment ");
        }
      } catch (e) {
        ErrorHandler.errorManger(context, e,
            title: "ZarinpalApi payment error", showSnackbar: true);
      }
    });
  }
///test api
  static tesPayment(BuildContext context,
      {required String phone,
      required String planId,
      required String subsId,
      required int amount}) async {
    try {
      final res = await http.post(Uri.parse("$hostUrl/payment/test_payment.php?phone=$phone&amount=$amount&appName=$kAppName&planId=$planId&subsId=$subsId"),);
      print(res.body);
      if (res.statusCode == 200) {
        var backData = jsonDecode(res.body);
        if (backData["success"] == true) {
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
  }
}
