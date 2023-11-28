import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/subscription.dart';
import 'package:hitop_cafe/screens/side_bar/purchase_app/services/zarinpal_api.dart';
import 'package:hitop_cafe/services/backend_services.dart';
import 'package:zarinpal/zarinpal.dart';

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



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        decoration: const BoxDecoration(
          gradient: kMainGradiant,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FutureBuilder(
                future:BackendServices().readOption("hitop_cafe_price") ,
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
                          const SizedBox(
                            height: 50,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(addSeparator(price),style: const TextStyle(color: Colors.white,fontSize: 30),),
                                    const Text("تومان",style: TextStyle(color: Colors.white38),),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                const Center(
                                    child: Text(
                                  "ویژگی های نسخه کامل برنامه :",
                                  style: TextStyle(color: Colors.yellow, fontSize: 17),
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
                            height: 50,
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
                    const Divider(
                      thickness: 0,
                    ),

                    const SizedBox(
                      height: 50,
                    ),

                    CustomButton(
                        text: "ادامه فرایند خرید",
                        color: Colors.green,
                        onPressed: ()async {

                          if (_formKey.currentState!.validate()) {
                            if(widget.level==null) {
                              Subscription subs = Subscription()
                                ..phoneNumber = widget.phone
                                ..name = (userFullNameController.text)
                                ..level = 0
                                ..payAmount=1100
                                ..email = emailController.text;
                              await BackendServices().createSubscription(subs).whenComplete((){
                                if (context.mounted) {
                                  ZarinpalApi.payment(context,
                                      amount: 5000,
                                      phone: widget.phone);
                                }
                              });
                            }

                          }
                        }),
                  ],
                ),
              ),

            ],
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
