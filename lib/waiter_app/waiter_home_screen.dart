import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/card_button.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/screens/orders_screen/add_order_screen.dart';
import 'package:hitop_cafe/screens/side_bar/setting/server_screen/local_server_screen.dart';
import 'package:hitop_cafe/waiter_app/waiter_setting_screen.dart';

class WaiterHomeScreen extends StatelessWidget {
  static const String id="/waiter-home-screen";
  const WaiterHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text("سفارشگیر"),),
      body: Container(
        alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(),
          child: SizedBox(
            width: 450,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text("waiter screen"),
                CardButton(
                    label: "افزودن سفارش",
                    width: 200,
                    image: "orders-history",
                    onTap: () {

                        Navigator.pushNamed(
                            context, AddOrderScreen.id);
                    }),
                ///network connection setting
                CardButton(
                    label: "تنظیمات شبکه",
                    height: 80,
                    width: 200,
                    verticalDirection: false,
                    image: "orders-history",
                    onTap: () {

                        Navigator.pushNamed(
                            context, WaiterSettingScreen.id);
                    }),
                CustomButton(text: "text", onPressed: (){
                  Navigator.pushNamed(context, LocalServerScreen.id);
                })
              ],
            ),
          )),
    );
  }
}
