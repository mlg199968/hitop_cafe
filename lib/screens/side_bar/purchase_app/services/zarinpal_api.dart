
import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/private.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zarinpal/zarinpal.dart';

class ZarinpalApi{

static  payment(BuildContext context,{required String phone,required int amount}) {
  PaymentRequest paymentRequest=PaymentRequest()
      ..setIsSandBox(true)
      ..setAmount(amount)
      ..setDescription("description")
      ..setMerchantID(PrivateKeys.zarinpalId)
      ..setCallbackURL("https://mlggrand.ir/verify?phone=$phone&amount=$amount");

    ZarinPal().startPayment(paymentRequest, (status, paymentGatewayUri) {
      try {
        if (status == 100) {
          launchUrl(Uri.parse(paymentGatewayUri!),
              mode: LaunchMode.externalApplication);
        } else {
          showSnackBar(context, "error $status on the ZarinPalApi.payment ");
        }
      }catch(e){
        debugPrint("pay option error..\n $e" );
      }
    });
  }
}