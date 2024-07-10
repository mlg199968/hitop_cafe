
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/common/widgets/dynamic_button.dart';
import 'package:hitop_cafe/common/widgets/empty_holder.dart';
import 'package:hitop_cafe/common/widgets/hide_keyboard.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/error_handler.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/server_models/device.dart';
import 'package:hitop_cafe/models/subscription.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/screens/home_screen/home_screen.dart';
import 'package:hitop_cafe/screens/side_bar/purchase_app/services/zarinpal_api.dart';
import 'package:hitop_cafe/services/backend_services.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:provider/provider.dart';

import '../../../models/plan.dart';

class PlanScreen extends StatefulWidget {
  static const String id = "/plan-screen";

  const PlanScreen({
    super.key,
    required this.phone,
    this.subsId,
  });
  final String phone;
  final int? subsId;
  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final userFullNameController = TextEditingController();
  final authCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late Future _getPlansFromHost;
 Plan? selectedPlan;

  List<String> warningList=[
    "اگر شرایط پرداخت آنلاین را ندارید با پشتیبانی تماس بگیرید",
    " در فرایند خرید حتما از اینترنت پایدار استفاده کنید تا مشکلی رخ ندهد",
    "بعد از خرید موفق و دیدن صفحه پرداخت موفق جهت فعال سازی از برنامه خارج شده و در حینی که به اینترنت متصل هستید وارد برنامه شوید تا برنامه فعال شود",
    "برنامه روی شماره تلفن و دستگاه شما فعال می شود و فقط در این دستگاه و شماره تلفن قابل اجرا هست و اگر قصد تغییر دستگاه را دارید با پشتیبانی هماهنگ کنید",
    "اگر در حین مراحل خرید و فعال سازی مشکلی رخ داد بلافاصله به پشتیبانی اطلاع دهید",
  ];
  ///button function
  purchaseButtonFunc(context, Plan plan) async {
    try {
      Device? device = await getDeviceInfo();
      Subscription subs = Subscription()
        ..phone = widget.phone
        ..name = userFullNameController.text
        ..level = 0
        ..amount = plan.price.toInt()
        ..device = device
        ..appName=kAppName
        ..fetchDate = DateTime.now()
        ..platform = device.platform
        ..email = emailController.text
        ..id = widget.subsId;

      String? subsId = await BackendServices.createSubs(context, subs: subs);
      if (subsId!=null) {
        Provider.of<UserProvider>(context, listen: false).setSubscription(subs);
        await ZarinpalApi.payment(
            context,
            amount: subs.amount!,
            planId: plan.id,
            subsId:subsId.toString(),
            phone: subs.phone);
        // await ZarinpalApi.tesPayment(
        //     context,
        //     amount: subs.amount!,
        //     planId: plan.id,
        //     subsId:subsId.toString(),
        //     phone: subs.phone);
        // Navigator.pushReplacementNamed(context, HomeScreen.id);
      }
    } catch (error) {
      ErrorHandler.errorManger(context, error,
          title: "خطا در ایجاد و ورود به فرایند خرید",
          route: "PlanScreen purchaseButtonFunc error",
          showSnackbar: true);
    }
  }

  @override
  void initState() {
    _getPlansFromHost = BackendServices().readPlans();
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: kBlackWhiteGradiant,
              borderRadius: BorderRadius.circular(20),
            ),
            child: FutureBuilder(
                future: _getPlansFromHost,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    List<Plan> plans=snapshot.data;
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ///top crown Icon
                          const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CText("خرید اشتراک",fontSize: 20,),
                              CrownIcon(size: 40,),
                            ],
                          ),

                          const Gap(20),
                           Column(
                             children: plans.map((plan) {
                                 return PlanHolder(
                                   selected: selectedPlan?.id==plan.id,
                                   plan: plan,
                                   onChange: (val){
                                     selectedPlan=val;
                                     setState(() {});
                                   },
                                 );
                             },
                           ).toList(),
                           ),
                          ///info and purchase part
                           Directionality(
                            textDirection: TextDirection.rtl,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Gap(50),

                                const Center(
                                    child: Text(
                                      "نکات مهم قبل و بعد از خرید:",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 17),
                                    )),
                                Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children:warningList.map((e) => TextWithIcon(
                                        text:
                                        e),).toList()
                                ),
                              ],
                            ),
                          ),

                          const Gap(20),
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
                                    label: "ایمیل",
                                    controller: emailController),
                                const Gap(20),
                                DynamicButton(
                                    label: "ادامه فرایند خرید",
                                    bgColor: Colors.orange,
                                    onPress: () async {
                                      if (_formKey.currentState!.validate()) {
                                        if(selectedPlan!=null) {
                                          purchaseButtonFunc(context, selectedPlan!);
                                        }else{
                                          showSnackBar(context, "اشتراک انتخاب نشده است!",type: SnackType.warning);
                                        }
                                      }
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const EmptyHolder(
                            text: "خطا در برقراری ارتباط با سرور",
                            icon: Icons
                                .signal_wifi_connected_no_internet_4_rounded),
                        ActionButton(
                          icon: Icons.refresh_rounded,
                          label: "تلاش دوباره",
                          onPress: () async {
                            _getPlansFromHost =
                                BackendServices().readPlans();
                            setState(() {});
                          },
                        ),
                      ],
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }
}

class PlanHolder extends StatelessWidget {
  const PlanHolder({
    super.key,
    required this.onChange,this.selected=false, required this.plan,
  });

  final Plan plan;
  final Function(Plan plan) onChange;
  final bool selected;
  List<Color> get colors {
    if(plan.type == "m1") {
      return[Colors.indigo, Colors.teal];
    }
    else if(plan.type == "m6"){
      return[Colors.indigo, Colors.deepOrangeAccent];
    }
    else if(plan.type == "m12"){
      return[Colors.indigo, Colors.purple];
    }
    else if(plan.type == "free"){
      return[Colors.indigo, Colors.teal];
    }
    else {
      return[Colors.grey, Colors.blueGrey];
    }

  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onChange(plan);
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        width: 400,
        height: 80,
        decoration: BoxDecoration(
            gradient: kBlackWhiteGradiant,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: selected?Colors.orange:Colors.black54,
            width: selected?2:0.5
          ),
          boxShadow:selected? [const BoxShadow(color: Colors.orange,blurRadius: 10)]:null
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: PriceHolder(price: plan),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
                gradient: LinearGradient(
                  colors: colors,
                ),

              ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CText("اشتراک",fontSize: 10,color: Colors.amberAccent,),
                    CText(plan.title,fontSize: 15,color: Colors.white,),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
///
class PriceHolder extends StatelessWidget {
  const PriceHolder({
    super.key,
    required this.price,
  });

  final Plan price;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: TextDirection.rtl,
          textBaseline: TextBaseline.ideographic,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ///discount percent
            if (price.hasDiscount)
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20)),
                  child: CText(
                    "${price.discount}%".toPersianDigit(),
                    color: Colors.white,
                  )),
            CText(
              addSeparator(price.price),
              color: Colors.black,
              fontSize: 20,
            ),
            const Gap(5),
            const CText(
              "تومان",
              color: Colors.black45,
              fontSize: 10,
            ),
          ],
        ),

        ///main price
        if (price.hasDiscount)
          Text(
            addSeparator(price.mainPrice),
            style: const TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.black38,
                fontSize: 14),
          ),
        const Gap(5),
      ],
    );
  }
}
///
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
            Icons.info,
            color: Colors.redAccent,
            size: 17,
          ),
          const SizedBox(
            width: 8,
          ),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
              maxLines: 4,
            ),
          ),
        ],
      ),
    );
  }
}

///
class CrownIcon extends StatelessWidget {
  const CrownIcon({
    super.key, this.size=70,
  });
  final double size;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ShaderMask(
        shaderCallback: (rect) => const LinearGradient(
          colors: [
            Colors.orangeAccent,
            Colors.yellow,
            Colors.orangeAccent,
          ],
        ).createShader(rect),
        child:  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Icon(
            CupertinoIcons.star_circle_fill,
            size: size,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}