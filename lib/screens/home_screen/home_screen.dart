import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/card_button.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/common/widgets/small_card_button.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/consts_class.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/global.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/screens/analytics/analytics_screen.dart';
import 'package:hitop_cafe/screens/items_screen/items_screen.dart';
import 'package:hitop_cafe/screens/orders_screen/order_screen.dart';
import 'package:hitop_cafe/screens/present_orders/present_order_screen.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/raw_ware_screen.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/screens/shopping-bill/shopping-bill-screen.dart';
import 'package:hitop_cafe/screens/side_bar/notice_screen/notice_screen.dart';
import 'package:hitop_cafe/screens/side_bar/notice_screen/services/notice_tools.dart';
import 'package:hitop_cafe/screens/side_bar/sidebar_panel.dart';
import 'package:hitop_cafe/screens/user_screen/panels/active_user_panel.dart';
import 'package:hitop_cafe/screens/user_screen/services/user_tools.dart';
import 'package:hitop_cafe/screens/user_screen/user_list_screen.dart';
import 'package:lottie/lottie.dart';
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
bool showAlertNotice=true;
  final List screens = [
    const OrderScreen(),
    const PresentOrderScreen(),
    const ItemsScreen(),
    const WareListScreen(),
    const ShoppingBillScreen(),
    const AnalyticsScreen(),
    const UserListScreen(),
  ];
  int screenIndex = 0;

  ///when screen width it's getting large onTap button function change to change screen with index
  onTapFunction(int index, VoidCallback onTap) {
    screenIndex = index;
    if (screenType(context) == ScreenType.desktop) {
      setState(() {});
    } else {
      onTap();
    }
  }

  @override
  void initState() {
    super.initState();

    ///get start up data
    // GlobalTask.getInitData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: mainScaffoldKey,
     // extendBodyBehindAppBar: true,
      drawer: const SideBarPanel(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          color: Colors.black54,
            onPressed: () {
              mainScaffoldKey.currentState!.openDrawer();
            },
            icon: const Icon(
              FontAwesomeIcons.bars,
              size: 30,
            )),
        title: Row(
          textBaseline: TextBaseline.alphabetic,
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
            const Flexible(
              child: Text(
                "HITOP Cafe ",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        actions: [
          ///manage
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ActionButton(
              label: "کاربر",
              icon: Icons.supervised_user_circle,
              bgColor: kSecondaryColor,
              onPress: (){
                showDialog(context: context, builder: (context)=>const ActiveUserPanel());
              },
            ),
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            children: [
              ///extent panel in desktop view
              if (screenType(context) == ScreenType.desktop)
                Expanded(
                  flex: 3,
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Container(
                      margin: const EdgeInsets.only(right: 20,left: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.red),
                      child: screens[screenIndex],
                    ),
                  ),
                ),
              Flexible(
                flex: 2,
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      ///home screen header
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        height: 200,
                        decoration: const BoxDecoration(
                          gradient: kMainGradiant,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ///Notification snack
                              AnimatedSize(
                                curve: Curves.easeInOutExpo,
                                duration: const Duration(milliseconds: 400),
                                child: (!NoticeTools.checkNewNotifications() ||
                                    !showAlertNotice)
                                    ? const SizedBox()
                                    : Container(
                                  width: 350,
                                  height: 50,
                                  decoration:  BoxDecoration(
                                      color: Colors.red,
                                  borderRadius: BorderRadius.circular(50)
                                  ),
                                  child: Row(
                                    textDirection: TextDirection.rtl,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      ActionButton(
                                        label: "مشاهده",
                                        bgColor: Colors.black12,
                                        icon: Icons.remove_red_eye_outlined,
                                        height: 30,
                                        onPress: () {
                                          Navigator.pushNamed(
                                              context, NoticeScreen.id)
                                              .then((value) {
                                            setState(() {});
                                          });
                                        },
                                      ),
                                      const CText(
                                        "اطلاع رسانی جدید!",
                                        color: Colors.white,
                                        textDirection: TextDirection.rtl,
                                      )
                                          .animate()
                                          .fade(duration: const Duration(seconds: 1)),
                                      Lottie.asset(
                                          "assets/animations/notification.json"),
                                      IconButton(
                                          color: Colors.white60,
                                          onPressed: () {
                                            showAlertNotice = false;
                                            setState(() {});
                                          },
                                          icon: const Icon(Icons.close_rounded))
                                    ],
                                  ),
                                ),
                              ),
                              const Gap(10),
                              ///show time
                              Text(
                                "امروز: ${DateTime.now().toPersianDateStr()}",
                                style: const TextStyle(color: Colors.white, fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(top:120),
                        padding: const EdgeInsets.all(20),
                        child: Center(

                            ///card button sections
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
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
                                      onTap: () {
                                        onTapFunction(1, () {
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
                                        onTapFunction(0, () {
                                          Navigator.pushNamed(
                                              context, OrderScreen.id);
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
                                onTap: () {
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
                                onTap: () {
                                  onTapFunction(3, () {
                                    Navigator.pushNamed(
                                        context, WareListScreen.id);
                                  });
                                }),

                            Align(
                              alignment: Alignment.bottomCenter,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SmallCardButton(
                                        label: "فاکتور خرید",
                                        image: "bills.jpg",
                                        onTap: () {
                                          onTapFunction(4, () {
                                            if(UserTools.userPermission(context,userTypes: [UserType.accountant,UserType.manager,])) {
                                              Navigator.pushNamed(
                                                context, ShoppingBillScreen.id);
                                            }
                                          });
                                        }),
                                    SmallCardButton(
                                        label: "آنالیز",
                                        image: "analytics3.png",
                                        onTap: () {
                                          onTapFunction(5, () {
                                            if(UserTools.userPermission(context,userTypes: [UserType.accountant])) {
                                              Navigator.pushNamed(
                                                  context, AnalyticsScreen.id);
                                            }
                                          });
                                        }),
                                  ],
                                ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
