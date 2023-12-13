import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hitop_cafe/common/widgets/card_button.dart';
import 'package:hitop_cafe/common/widgets/small_card_button.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/global.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/screens/analytics/analytics_screen.dart';
import 'package:hitop_cafe/screens/items_screen/items_screen.dart';
import 'package:hitop_cafe/screens/orders_screen/order_screen.dart';
import 'package:hitop_cafe/screens/present_orders/present_order_screen.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/raw_ware_screen.dart';
import 'package:hitop_cafe/screens/shopping-bill/shopping-bill-screen.dart';
import 'package:hitop_cafe/screens/side_bar/notice_screen/notice_screen.dart';
import 'package:hitop_cafe/screens/side_bar/sidebar_panel.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "/home-screen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> mainScaffoldKey = GlobalKey<ScaffoldState>();


  final List screens=[
    const OrderScreen(),
    const PresentOrderScreen(),
    const ItemsScreen(),
    const WareListScreen(),
    const ShoppingBillScreen(),
    const AnalyticsScreen(),
  ];
  int screenIndex=0;
  ///when screen width it's getting large onTap button function change to change screen with index
  VoidCallback onTapFunction(int index,VoidCallback onTap){
    screenIndex=index;
    if(screenType(context)==ScreenType.desktop){
      setState(() {});
      print(index);
      print("current index");
      print(screenIndex);
    }else {
      return onTap;
    }
    return (){};
  }

@override
  void initState() {
    super.initState();
    ///get start up data
    GlobalFunc.getInitData(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
          textBaseline:TextBaseline.alphabetic,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          mainAxisSize: MainAxisSize.min,
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
                  color: Colors.white70,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          ///Notification icon button
          IconButton(
              color: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, NoticeScreen.id);
              },
              icon: const Icon(Icons.notifications,size: 25,)),
          ///hitop icon
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(right: 0),
            child: GestureDetector(
              onTap: () {
                //Navigator.pushNamed(context, SignInScreen.id);
              },
              child: Image.asset(
                'assets/icons/hitop-white.png',
                width: 100,
                height: 40,
              ),
            ),
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
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
              child:  Center(
                child: Wrap(
                  children: [
                    Text("امروز: ${DateTime.now().toPersianDateStr()}",style: const TextStyle(color: Colors.white,fontSize: 17),),
                  ],
                ),
              ),
            ),
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height * .2),
              padding: const EdgeInsets.all(20),

              ///card button sections
              child: Row(
                textDirection: TextDirection.ltr,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(screenType(context)==ScreenType.desktop)
                  Expanded(
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.red
                        ),
                        child: screens[screenIndex],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Center(
                        child: Column(
                      children: [

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 3,
                              child: CardButton(
                                  label: "سفارشات حاضر",
                                  width: 300,
                                  image: "active-orders",
                                  onTap:() {
                                    onTapFunction(0, () {
                                      Navigator.pushNamed(
                                          context, PresentOrderScreen.id);
                                    });
                                  }),
                            ),
                            Flexible(
                              flex: 2,
                              child: CardButton(
                                  label: "تاریخچه سفارشات",
                                  width: 200,
                                  image: "orders-history",
                                  onTap: () {
                                    onTapFunction(1, () {
                                      Navigator.pushNamed(context, OrderScreen.id);
                                    });

                                  }),
                            ),
                          ],
                        ),

                        ///ware house button raw wares and main items

                        CardButton(
                            label: "لیست آیتم ها ",
                            width: 400,
                            height: 100,
                            image: "items",
                            verticalDirection: false,
                            onTap: (){
                              onTapFunction(2, () {
                                Navigator.pushNamed(context, ItemsScreen.id);
                              });
                            }),
                        CardButton(
                            label: "لیست مواد خام ",
                            width: 400,
                            height: 100,
                            image: "raw-wares",
                            verticalDirection: false,
                            onTap: (){
                              onTapFunction(3, () {
                                Navigator.pushNamed(context, WareListScreen.id);
                              });
                            }),

                        Align(
                          alignment: Alignment.bottomRight,
                          child: Wrap(
                            children: [
                              SmallCardButton(
                                  label: "فاکتور خرید",
                                  image: "bills.jpg",
                                  onTap: () {
                                    onTapFunction(4, () { Navigator.pushNamed(context, ShoppingBillScreen.id);});

                                  }),
                              SmallCardButton(
                                  label: "آنالیز",
                                  image: "analytics.png",
                                  onTap: () {
                                    onTapFunction(5, () { Navigator.pushNamed(context, AnalyticsScreen.id);});

                                  }),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
