import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/card_button.dart';
import 'package:hitop_cafe/common/widgets/small_card_button.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/providers/ware_provider.dart';
import 'package:hitop_cafe/screens/items_screen/items_screen.dart';
import 'package:hitop_cafe/screens/orders_screen/order_screen.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/raw_ware_screen.dart';
import 'package:hitop_cafe/screens/shopping-bill/shoping-bill-screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const String id = "/home-screen";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<WareProvider>(context,listen: false).loadCategories();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ///home screen header
            Container(
                width: double.maxFinite,
                height: 100,
                decoration: const BoxDecoration(gradient: kMainGradiant),
                child: const Center(child: Text("home Screen"))),
            Container(
              padding: const EdgeInsets.all(20),
              ///card button sections
              child: Center(
                  child: Column(
                children: [
                  ///order button card
                  CardButton(
                      label: "سفارشات",
                      width: 400,
                      image: "trending1",
                      verticalDirection: false,
                      onTap: () {
                        Navigator.pushNamed(context, OrderScreen.id);
                      }),
                  ///ware house button raw wares and main items
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                          child: CardButton(
                              label: "لیست مواد خام ",
                              width: 200,
                              image: "trending2",
                              onTap: () {
                                Navigator.pushNamed(
                                    context, WareListScreen.id);
                              })),
                      Flexible(
                          child: CardButton(
                              label: "لیست آیتم ها ",
                              width: 200,
                              image: "trending3",
                              onTap: () {
                                Navigator.pushNamed(
                                    context, ItemsScreen.id);
                              })),
                    ],
                  ),
                  Wrap(
                    children: [
                      SmallCardButton(label: "فاکتور خرید",image: "profile.png", onTap: (){
                        Navigator.pushNamed(context, ShoppingBillScreen.id);
                      }),
                    ],
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
