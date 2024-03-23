import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/card_button.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/models/shop.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/screens/splash_screen/splash_screen.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:hitop_cafe/waiter_app/waiter_home_screen.dart';
import 'package:provider/provider.dart';

class AppTypeScreen extends StatefulWidget {
  static const String id = "/app-type-screen";

  const AppTypeScreen({super.key});

  @override
  State<AppTypeScreen> createState() => _AppTypeScreenState();
}

class _AppTypeScreenState extends State<AppTypeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),

          decoration: const BoxDecoration(gradient: kMainGradiant),
          child: SizedBox(
            width: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CText(
                  "انتخاب نوع کاربری",
                  fontSize: 18,
                  color: Colors.white,
                  textDirection: TextDirection.rtl,
                ),
                const Gap(30),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    CardButton(
                      image: "waiter.png",
                      label: "سفارشگیر",
                      fit: BoxFit.fitHeight,

                      onTap: () {
                        Shop shop = HiveBoxes.getShopInfo().values.single;
                        shop.appType = AppType.waiter.value;
                        HiveBoxes.getShopInfo().putAt(0, shop);
                        Provider.of<UserProvider>(context, listen: false)
                            .getData(shop);
                        Navigator.pushReplacementNamed(
                            context, WaiterHomeScreen.id);
                      },
                    ),
                    CardButton(
                      image: "accountancy.png",
                      fit: BoxFit.fitWidth,
                      label: "برنامه اصلی",
                      onTap: () {
                        Shop shop = HiveBoxes.getShopInfo().values.first;
                        shop.appType = AppType.main.value;
                        HiveBoxes.getShopInfo().putAt(0, shop);
                        Navigator.pushReplacementNamed(context, SplashScreen.id);
                      },
                    ),
                  ],
                ),
                const Gap(30),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30,),
                  child: CText(
                    "در این بخش با توجه به نوع کاربری که از برنامه میخواهید یک گزینه را انتخاب کنید.\n بخش سفارشگیر نیاز است به برنامه اصلی در دستگاه دیگر نصب شود.",
                    color: Colors.white70,
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}


