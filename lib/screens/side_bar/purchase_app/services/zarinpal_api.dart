
import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/error_handler.dart';
import 'package:hitop_cafe/constants/private.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zarinpal/zarinpal.dart';

class ZarinpalApi{

static  payment(BuildContext context,{required String phone,required int amount}) async{
  String deviceId=await getDeviceInfo();
  PaymentRequest paymentRequest=PaymentRequest()
      ..setIsSandBox(false)
      ..setAmount(1000)
      ..setDescription("description")
      ..setMerchantID(PrivateKeys.zarinpalId)
      ..setCallbackURL("$hostUrl/payment/payzarin.php?phone=$phone&amount=$amount&device=$deviceId");

    ZarinPal().startPayment(paymentRequest, (status, paymentGatewayUri) {
      try {
        if (status == 100) {
          launchUrl(Uri.parse(paymentGatewayUri!),
              mode: LaunchMode.externalApplication);
        } else {
          showSnackBar(context, "error $status on the ZarinPalApi.payment ");
        }
      }catch(e){
        ErrorHandler.errorManger(context, e,title: "ZarinpalApi payment error",showSnackbar: true);
      }
    });
  }
}