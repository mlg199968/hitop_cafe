import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hitop_cafe/common/widgets/card_button.dart';
import 'package:hitop_cafe/common/widgets/small_card_button.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/consts_class.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/providers/ware_provider.dart';
import 'package:hitop_cafe/screens/analytics/analytics_screen.dart';
import 'package:hitop_cafe/screens/items_screen/items_screen.dart';
import 'package:hitop_cafe/screens/orders_screen/order_screen.dart';
import 'package:hitop_cafe/screens/present_orders/present_order_screen.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/raw_ware_screen.dart';
import 'package:hitop_cafe/screens/shopping-bill/shoping-bill-screen.dart';
import 'package:hitop_cafe/screens/side_bar/sidebar_panel.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "/home-screen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> mainScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Provider.of<WareProvider>(context, listen: false).loadCategories();
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        key: mainScaffoldKey,
        extendBodyBehindAppBar: true,
        drawer: const SideBarPanel(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
              color: Colors.white54,
              onPressed: () {
                mainScaffoldKey.currentState!.openDrawer();
              },
              icon: const Icon(
                FontAwesomeIcons.bars,
                size: 30,
              )),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Provider.of<UserProvider>(context, listen: false).userLevel == 1
                  ? const Icon(
                      FontAwesomeIcons.crown,
                      color: Colors.orangeAccent,
                    )
                  : const SizedBox(),
              const SizedBox(
                width: 5,
              ),
              const Text(
                "HITOP Cafe ",
                style: TextStyle(
                    color: Colors.white38,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              ///home screen header
              Container(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * .35,
                decoration: const BoxDecoration(
                  gradient: kMainGradiant,
                  borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(500, 70)),
                ),
                child: const Center(
                  child: Text("home Screen"),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(top: MediaQuery.of(context).size.height * .2),
                padding: const EdgeInsets.all(20),

                ///card button sections
                child: Center(
                    child: Column(
                  children: [
                    ///order button card
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: CardButton(
                              label: "تاریخچه سفارشات",
                              width: 200,
                              image: "trending1",
                              onTap: () {
                                Navigator.pushNamed(context, OrderScreen.id);
                              }),
                        ),
                        Flexible(
                          child: CardButton(
                              label: "سفارشات فعال",
                              width: 300,
                              image: "trending2",
                              onTap: () {
                                Navigator.pushNamed(context, PresentOrderScreen.id);
                              }),
                        ),
                      ],
                    ),

                    ///ware house button raw wares and main items

                    CardButton(
                        label: "لیست آیتم ها ",
                        width: 400,
                        height: 100,
                        image: "trending3",
                        verticalDirection: false,
                        onTap: () {
                          Navigator.pushNamed(context, ItemsScreen.id);
                        }),
                    CardButton(
                        label: "لیست مواد خام ",
                        width: 400,
                        height: 100,
                        image: "trending2",
                        verticalDirection: false,
                        onTap: () {
                          Navigator.pushNamed(context, WareListScreen.id);
                        }),

                    Wrap(
                      children: [
                        SmallCardButton(
                            label: "فاکتور خرید",
                            image: "photo2.jpg",
                            onTap: () {
                              Navigator.pushNamed(context, ShoppingBillScreen.id);
                            }),
                        SmallCardButton(
                            label: "آنالیز",
                            image: "photo3.jpg",
                            onTap: () {
                              Navigator.pushNamed(context, AnalyticsScreen.id);
                            }),
                      ],
                    ),
                    const SizedBox(
                      height: 600,
                    ),
                  ],
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
