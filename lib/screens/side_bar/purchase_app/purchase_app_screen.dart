import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/common/widgets/hide_keyboard.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/screens/home_screen/home_screen.dart';
import 'package:hitop_cafe/screens/side_bar/purchase_app/services/zarinpal_api.dart';
import 'package:hitop_cafe/services/HttpUtil.dart';
import 'package:hitop_cafe/services/backend_services.dart';
import 'package:provider/provider.dart';


class PurchaseAppScreen extends StatefulWidget {
  static const String id = "/purchase-app-screen";

  const PurchaseAppScreen({
    super.key,
    required this.phone, this.level,
  });
  final String phone;
  final int? level;
  @override
  State<PurchaseAppScreen> createState() => _PurchaseAppScreenState();
}

class _PurchaseAppScreenState extends State<PurchaseAppScreen> {
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final userFullNameController = TextEditingController();
  final authCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late Future _getPriceFromHost;

  ///button function
  purchaseButtonFunc() async {
    Map<String, dynamic>? deviceId = await getDeviceInfo();
    Map<String, dynamic>? dynamicData = deviceId;
    // Other string data
    final platform = deviceId?["platform"].toString();
    final level = UserProvider().level;
    final phone = widget.phone;
    final name = userFullNameController.text;
    final email = emailController.text;
    try {
      // Combine dynamic data and other data
      Map<String, dynamic> requestData = {
        'deviceId': dynamicData,
        'level': level,
        'phone': phone,
        'platform': platform,
        'name': name,
        'email': email,
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
      //
      if (responseData) {
        String? value = widget.phone;
        Map<String, dynamic>? deviceId = await getDeviceInfo();
        Map<String, dynamic>? searchParams = deviceId;
        debugPrint("dynamic data READ$searchParams");
        Map<String, dynamic> requestData = {
          'deviceId': searchParams,
          'phone': value,
        };
        debugPrint("here is data for READ $requestData");
        String url = 'https://mlggrand.ir/db/user/read_subscription.php?'
            'id=${searchParams?['id']}&brand=${searchParams?['brand']}&platform=${searchParams?['platform']}&phone=$value';
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
              if (context.mounted) {
                Provider.of<UserProvider>(context, listen: false)
                    .setLevel(level);
                Navigator.pushNamed(context, HomeScreen.id);
              }
            } else {
              if (context.mounted) {
                Provider.of<UserProvider>(context, listen: false)
                    .setLevel(level);
                ZarinpalApi.payment(context, amount: 5000, phone: widget.phone);
                Navigator.pushNamed(context, HomeScreen.id);
              }
            }
          } else {
            print('Failure message: ${response["message"]}');
          }
        } else {
          print('-------context is not available-------');
          if (context.mounted) {
            Provider.of<UserProvider>(context, listen: false).setLevel(level);
            ZarinpalApi.payment(context, amount: 5000, phone: widget.phone);
            Navigator.pushNamed(context, HomeScreen.id);
          }
        }
      }
    } catch (error) {
      print("Errorooooooooooooooooo: $error");
    }
  }
  ///button function
// purchaseButtonFunc()async{
//   if(widget.level==null) {
//     Subscription subs = Subscription()
//       ..phoneNumber = widget.phone
//       ..name = (userFullNameController.text)
//       ..level = 0
//       ..payAmount=1100
//       ..email = emailController.text;
//     await BackendServices().createSubscription(context,subs).whenComplete((){
//       if (context.mounted) {
//         ZarinpalApi.payment(context,
//             amount: 5000,
//             phone: widget.phone);
//       }
//     });
//   }
// }

  @override
  void initState() {
    _getPriceFromHost=BackendServices().readOption("hitop_cafe_price");
    super.initState();
  }
  @override
  void dispose() {
    phoneNumberController.dispose();
    emailController.dispose();
    userFullNameController.dispose();
    authCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyboard(
      child: Scaffold(
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
            height: 800,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: kBlackWhiteGradiant,borderRadius: BorderRadius.circular(20),
            ),
            child: FutureBuilder(
                future:_getPriceFromHost ,
                builder: (context,snapshot) {

                  if(snapshot.connectionState==ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator());
                  }
                  else if(snapshot.connectionState==ConnectionState.done && snapshot.hasData) {
                    int price=int.parse(snapshot.data);
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ///top crown Icon
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
                                FontAwesomeIcons.crown,
                                size: 80,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          ///info and purchase part
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 50),
                                Row(
                                  textBaseline: TextBaseline.ideographic,
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(addSeparator(price),style: const TextStyle(color: Colors.black,fontSize: 30),),
                                    const SizedBox(width: 5,),
                                    const Text("تومان",style: TextStyle(color: Colors.black45),),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                const Center(
                                    child: Text(
                                      "ویژگی های نسخه کامل برنامه :",
                                      style: TextStyle(color: Colors.amber, fontSize: 17),
                                    )),
                                const SizedBox(height: 20),
                                const TextWithIcon(text: " افزودن نامحدود سفارش "),
                                const TextWithIcon(text: "افزودن نامحدود کالا به لیست"),
                                const TextWithIcon(text: "امکان گرفتن فایل پشتیبان"),
                                const TextWithIcon(text: "دسترسی به بخش تنظیمات"),
                                const TextWithIcon(text: "صدور نامحدود فاکتور"),
                                const SizedBox(
                                  height: 25,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ///full name text field
                                CustomTextField(
                                    validate: true,
                                    label: "نام و نام خانوادگی",
                                    controller: userFullNameController),
                                const Divider(
                                  thickness: 0,
                                ),
                                CustomTextField(
                                    label: "ایمیل", controller: emailController),


                                const SizedBox(
                                  height: 20,
                                ),

                                CustomButton(
                                    text: "ادامه فرایند خرید",
                                    color: Colors.orange,
                                    onPressed: ()async {
                                      if (_formKey.currentState!.validate()) {
                                        purchaseButtonFunc();
                                      }
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  else{
                    return const Center(child: Text("خطا در برقراری ارتباط با سرور",style: TextStyle(color: Colors.white),));
                  }
                }
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
            color: Colors.amberAccent,
            size: 17,
          ),
          const SizedBox(
            width: 8,
          ),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
