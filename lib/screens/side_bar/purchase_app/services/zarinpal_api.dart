
import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/error_handler.dart';
import 'package:hitop_cafe/constants/private.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zarinpal/zarinpal.dart';

class ZarinpalApi{

static  payment(BuildContext context,{required String phone,required int amount}) async{
  String deviceId=await getDeviceInfo();
  PaymentRequest paymentRequest=PaymentRequest()
      ..setIsSandBox(true)
      ..setAmount(amount)
      ..setDescription("description")
      ..setMerchantID(PrivateKeys.zarinpalId)
      ..setCallbackURL("https://mlggrand.ir/verify?phone=$phone&amount=$amount&device=$deviceId");

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