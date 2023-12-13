import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/screens/home_screen/home_screen.dart';
import 'package:hitop_cafe/screens/side_bar/purchase_app/purchase_app_screen.dart';
import 'package:hitop_cafe/screens/side_bar/purchase_app/services/payamito_api.dart';
import 'package:hitop_cafe/services/backend_services.dart';
import 'package:provider/provider.dart';
import 'package:zarinpal/zarinpal.dart';

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

  PaymentRequest paymentRequest = PaymentRequest();
  bool isRightNumber = false;
  String? sendCode;
  String? payReference;


  authorityFunction()async{
    await BackendServices()
        .readSubscription(
        context, phoneNumberController.text)
        .then((value) {
      if(value!=null && value.level!=0){
        // print(value.toMap());
        Provider.of<UserProvider>(context,listen: false).setUserLevel(value.level);
        Navigator.pushNamed(context, HomeScreen.id);
      }else {
        print("no match phone number found in mySql");
        Navigator.pushReplacementNamed(
            context, PurchaseAppScreen.id,arguments: {
          "phone":phoneNumberController.text,
          "level":value?.level
        });
      }
      return null;

    });
  }

  @override
  void dispose() {
    authCodeController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: const BoxDecoration(
          gradient: kMainGradiant,
        ),
        child: Container(
          width: 450,
          height: 550,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: kBlackWhiteGradiant,
            borderRadius: BorderRadius.circular(20)
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ///top Person Icon
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.orangeAccent,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          width: 5),
                      shape: BoxShape.circle,
                    ),
                    child: ShaderMask(
                      shaderCallback: (rect) => const LinearGradient(
                        colors: [
                          Colors.orangeAccent,
                          Colors.yellow,
                          Colors.orangeAccent,
                        ],
                      ).createShader(rect),
                      child: const Icon(
                        Icons.person,
                        size: 120,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 50,
                        ),

                        ///phone number field and auth button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButton(
                                text: "ارسال کد",
                                height: 40,
                                color: Colors.teal,
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    Map? phoneAuthData =
                                        await PayamitoApi.sentMessage(
                                            context, phoneNumberController.text);
                                    if(phoneAuthData!=null) {
                                      isRightNumber = phoneAuthData["isRight"];
                                      sendCode = phoneAuthData["authCode"];
                                    }
                                    setState(() {});
                                  }
                                }),
                            const VerticalDivider(
                              width: 8,
                            ),
                            Expanded(
                              child: CustomTextField(
                                label: "شماره موبایل",
                                controller: phoneNumberController,
                                textFormat: TextFormatter.number,
                                maxLength: 11,
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
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),

                        ///show code textfield when authorization code has been sent
                        if (isRightNumber)
                          CustomTextField(
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
                        const SizedBox(
                          height: 18,
                        ),
                        if (isRightNumber)
                          CustomButton(
                              text: "احراز هویت",
                              color: Colors.green,
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  authorityFunction();
                                }
                              }),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
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
