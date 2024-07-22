
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/error_handler.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/server_models/device.dart';
import 'package:hitop_cafe/models/subscription.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/screens/home_screen/home_screen.dart';
import 'package:hitop_cafe/screens/side_bar/purchase_app/plan_screen.dart';
import 'package:hitop_cafe/screens/side_bar/purchase_app/purchase_app_screen.dart';
import 'package:hitop_cafe/screens/side_bar/purchase_app/services/payamito_api.dart';
import 'package:hitop_cafe/screens/side_bar/purchase_app/subscription_screen.dart';
import 'package:hitop_cafe/services/backend_services.dart';
import 'package:provider/provider.dart';
import 'package:zarinpal/zarinpal.dart';

import '../../../constants/enums.dart';

class AuthorityScreen extends StatefulWidget {
  static const String id = "/authority-screen";

  const AuthorityScreen({super.key});

  @override
  State<AuthorityScreen> createState() => _AuthorityScreenState();
}

class _AuthorityScreenState extends State<AuthorityScreen> {
  final phoneNumberController = TextEditingController();
  final authCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _codeFormKey = GlobalKey<FormState>();

  PaymentRequest paymentRequest = PaymentRequest();
  bool isRightNumber = false;
  bool patient = false;


  bool msgLoading = false;
  bool authLoading = false;
  String? sendCode;
  ///send code button function
Future<void> sendCodeFunction(context)async{
  msgLoading = true;
  setState(() {});
  try{
      Map? phoneAuthData =
          await PayamitoApi.sentMessage(context, phoneNumberController.text);

      if (phoneAuthData != null) {
        isRightNumber = phoneAuthData["isRight"];
        sendCode = phoneAuthData["authCode"];
      }
      msgLoading = false;
      patient=true;
    }catch(error){
    ErrorHandler.errorManger(context, error,
        title: "خطا در ارسال کد!",
        route: "AuthorityScreen sendCode button function error",
        showSnackbar: true);
    patient=false;
  }
  setState(() {});
  }


///authority button function
  Future<void> authorityFunction(context) async {
  authLoading=true;
  setState(() {});
    final phone = phoneNumberController.text;
    try {
      Map readSubs =
          await BackendServices.readSubs(context, phone);
      if (readSubs["success"]=true) {
        Subscription? subs=readSubs["subs"];
          if (subs!=null && subs.userLevel==1) {
            Provider.of<UserProvider>(context, listen: false)
              ..setUserLevel(1)..setSubscription(subs);
            BackendServices.updateFetchDate(context, subs);
            Navigator.pushReplacementNamed(context, SubscriptionScreen.id);
          }
          else if(subs!=null && subs.userLevel==0){
            Provider.of<UserProvider>(context, listen: false).setSubscription(subs);
            Navigator.pushReplacementNamed(context, SubscriptionScreen.id);
          }
          else{
            Navigator.pushReplacementNamed(context, PlanScreen.id,
                arguments: {"phone": phone, "subsId": null});
          }
      }
    } catch (error,stacktrace) {
      ErrorHandler.errorManger(context, error,
          stacktrace: stacktrace,
          title: "AuthorityScreen Authority button function error",
          showSnackbar: true);
    }
  authLoading=false;
  setState(() {});
  }
  ///button timer
  messageTimer(DateTime time){
    return TimerCountdown(
      enableDescriptions: false,
      timeTextStyle: const TextStyle(color: Colors.white70),
      colonsTextStyle: const TextStyle(color: Colors.white70),
      spacerWidth: 0,
      format: CountDownTimerFormat.minutesSeconds,
      endTime: DateTime.now().add(
        const Duration(
          seconds: 60,
        ),
      ),
      onEnd: () {
        patient=false;
        setState(() {});
      },
    );
  }
  @override
  void dispose() {
    authCodeController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile=screenType(context)==ScreenType.mobile;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: kMainGradiant,
        ),
        child: SingleChildScrollView(
          child: Container(
            width: 450,
            height: 550,
            margin:isMobile?const EdgeInsets.all(5).copyWith(top: 70):const EdgeInsets.all(15).copyWith(top: 70),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                gradient: kBlackWhiteGradiant,
                borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ///top Person Icon
                  ShaderMask(
                    shaderCallback: (rect) => const LinearGradient(
                      colors: [
                        Colors.black54,
                        Colors.black,
                        Colors.black12,
                      ],
                    ).createShader(rect),
                    child: const Icon(
                      Icons.person,
                      size: 200,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ///phone number field and auth button
                      Form(
                        key: _formKey,
                        child: CustomTextField(
                          label: "شماره موبایل",
                          controller: phoneNumberController,
                          textFormat: TextFormatter.number,
                          maxLength: 11,
                          borderRadius: 10,
                          validate: true,
                          extraValidate: (val) {
                            String newVal = val!;
                            if (val[0] == "0") {
                              newVal = val.replaceFirst("0", "");
                              phoneNumberController.text = newVal;
                            }
                            if (newVal.length < 10 || newVal[0] != "9") {
                              return "شماره معتبر نیست";
                            }
                          },
                          suffixIcon:ActionButton(
                            disable: patient,
                            child:patient? messageTimer(DateTime.now()):null,
                              loading: msgLoading,
                              label: "ارسال کد",
                              icon: Icons.send,
                              margin: const EdgeInsets.all(3).copyWith(left: 6),
                              height: 35,
                              borderRadius: 8,
                              bgColor: Colors.black87,
                              iconColor: Colors.amber,
                              onPress: () async {
                                if (_formKey.currentState!.validate()) {
                                  await sendCodeFunction(context);
                                }
                              }),
                        ),
                      ),
                      const Gap(50),

                      ///show code textfield when authorization code has been sent
                      if (isRightNumber)
                        Form(
                          key: _codeFormKey,
                          child: CustomTextField(
                            validate: true,
                            label: "کد ارسال شده",
                            textFormat: TextFormatter.number,
                            controller: authCodeController,
                            extraValidate: (val) {
                              if (sendCode != val) {
                                return "کد وارد شده معتبر نمی باشد!";
                              }
                            },
                          ),
                        ),
                      const Gap(8),
                      if (isRightNumber)
                        CustomButton(
                          loading: authLoading,
                            text: "احراز هویت",
                            icon: const Icon(Icons.person_search_rounded,color: Colors.tealAccent,),
                            color: Colors.teal,
                            radius: 10,
                            onPressed: () async {
                              if (_codeFormKey.currentState!.validate()) {
                                authorityFunction(context);
                              }
                            }),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  //TODO:my debug widget
                  ///just for debug mode
                  if(kDebugMode)
                  ActionButton(icon: Icons.gps_fixed_sharp,
                    onPress: (){
                    phoneNumberController.text="9910606073";
                    authorityFunction(context);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TextWithIcon extends StatelessWidget {
  const TextWithIcon({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Icon(
            FontAwesomeIcons.circleCheck,
            color: Colors.yellow,
            size: 17,
          ),
          const SizedBox(
            width: 8,
          ),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, color: Colors.white),
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
