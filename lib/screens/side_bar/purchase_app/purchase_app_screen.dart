import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/common/widgets/empty_holder.dart';
import 'package:hitop_cafe/common/widgets/hide_keyboard.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/error_handler.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/price.dart';
import 'package:hitop_cafe/models/server_models/device.dart';
import 'package:hitop_cafe/models/subscription.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/screens/home_screen/home_screen.dart';
import 'package:hitop_cafe/screens/side_bar/purchase_app/services/zarinpal_api.dart';
import 'package:hitop_cafe/services/backend_services.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:provider/provider.dart';

class PurchaseAppScreen extends StatefulWidget {
  static const String id = "/purchase-app-screen";

  const PurchaseAppScreen({
    super.key,
    required this.phone,
    this.subsId,
  });
  final String phone;
  final int? subsId;
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
  bool loading = false;

  ///button function
  purchaseButtonFunc(context, int price) async {
    loading = true;
    setState(() {});
    try {
      Device? device = await getDeviceInfo();
      Subscription subs = Subscription()
        ..phone = widget.phone
        ..name = userFullNameController.text
        ..level = 0
        ..amount = price
        ..device = device
        ..appName=kAppName
        ..fetchDate = DateTime.now()
        ..platform = device.platform
        ..email = emailController.text
        ..id = widget.subsId;

      bool created = await BackendServices.createSubs(context, subs: subs);
      if (created) {
        Provider.of<UserProvider>(context, listen: false).setSubscription(subs);
        await ZarinpalApi.payment(context,
            amount: subs.amount!, phone: subs.phone);
        Navigator.pushReplacementNamed(context, HomeScreen.id);
      }
    } catch (error) {
      ErrorHandler.errorManger(context, error,
          title: "خطا در ایجاد و ورود به فرایند خرید",
          route: "PurchaseAppScreen purchaseButtonFunc error",
          showSnackbar: true);
    }
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    _getPriceFromHost = BackendServices().readOption(kPriceOptionKey);
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
              gradient: kBlackWhiteGradiant,
              borderRadius: BorderRadius.circular(20),
            ),
            child: FutureBuilder(
                future: _getPriceFromHost,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    Price price = Price().fromJson(snapshot.data);
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
                                const Gap(50),

                                /// app price
                                PriceHolder(price: price),
                                const Gap(20),
                                const Center(
                                    child: Text(
                                  "نکات مهم قبل و بعد از خرید:",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 17),
                                )),
                                const Gap(20),
                                const TextWithIcon(
                                    text:
                                        "اگر شرایط پرداخت آنلاین را ندارید با پشتیبانی تماس بگیرید"),
                                const TextWithIcon(
                                    text:
                                        " در فرایند خرید حتما از اینترنت پایدار استفاده کنید تا مشکلی رخ ندهد"),
                                const TextWithIcon(
                                    text:
                                        "بعد از خرید موفق و دیدن صفحه پرداخت موفق جهت فعال سازی از برنامه خارج شده و در حینی که به اینترنت متصل هستید وارد برنامه شوید تا برنامه فعال شود"),
                                const TextWithIcon(
                                    text:
                                        "برنامه روی شماره تلفن و دستگاه شما فعال می شود و فقط در این دستگاه و شماره تلفن قابل اجرا هست و اگر قصد تغییر دستگاه را دارید با پشتیبانی هماهنگ کنید"),
                                const TextWithIcon(
                                    text:
                                        "اگر در حین مراحل خرید و فعال سازی مشکلی رخ داد بلافاصله به پشتیبانی اطلاع دهید"),
                                const Gap(25),
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

                                CustomButton(
                                    loading: loading,
                                    text: "ادامه فرایند خرید",
                                    color: Colors.orange,
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        purchaseButtonFunc(
                                            context, price.price.toInt());
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
                            _getPriceFromHost =
                                BackendServices().readOption(kPriceOptionKey);
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
///
class PriceHolder extends StatelessWidget {
  const PriceHolder({
    super.key,
    required this.price,
  });

  final Price price;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
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
                  child: Text(
                    "${price.discount}%".toPersianDigit(),
                    style: const TextStyle(color: Colors.white),
                  )),
            Text(
              addSeparator(price.price),
              style: const TextStyle(color: Colors.black, fontSize: 30),
            ),
            const SizedBox(
              width: 5,
            ),
            const Text(
              "تومان",
              style: TextStyle(color: Colors.black45),
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
                fontSize: 20),
          ),
        const SizedBox(
          width: 5,
        ),
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
