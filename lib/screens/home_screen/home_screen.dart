import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hitop_cafe/common/widgets/card_button.dart';
import 'package:hitop_cafe/common/widgets/small_card_button.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/user_permissions.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/screens/analytics/analytics_screen.dart';
import 'package:hitop_cafe/screens/customer_screen/customer_list_screen.dart';
import 'package:hitop_cafe/screens/items_screen/items_screen.dart';
import 'package:hitop_cafe/screens/note_list_screen/widgets/note_carousel.dart';
import 'package:hitop_cafe/screens/orders_screen/order_screen.dart';
import 'package:hitop_cafe/screens/present_orders/present_order_screen.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/raw_ware_screen.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/screens/shopping-bill/shopping-bill-screen.dart';
import 'package:hitop_cafe/screens/side_bar/notice_screen/services/notice_tools.dart';
import 'package:hitop_cafe/screens/side_bar/notice_screen/widgets/notice_carousel.dart';
import 'package:hitop_cafe/screens/side_bar/setting/backup/backup_tools.dart';
import 'package:hitop_cafe/screens/side_bar/sidebar_panel.dart';
import 'package:hitop_cafe/screens/user_screen/panels/active_user_panel.dart';
import 'package:hitop_cafe/screens/user_screen/services/user_tools.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import '../../common/widgets/custom_alert.dart';
import '../other_expenses_screen/other_expenses_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "/home-screen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WindowListener{
  final GlobalKey<ScaffoldState> mainScaffoldKey = GlobalKey<ScaffoldState>();
  late UserProvider userProvider;
  final List screens = [
    const OrderScreen(),
    const PresentOrderScreen(),
    const ItemsScreen(),
    const WareListScreen(),
    const ShoppingBillScreen(),
    const AnalyticsScreen(),
    const CustomerListScreen(),
    const OtherExpensesScreen(),
  ];
  int screenIndex = 0;

  ///when screen width it's getting large onTap button function change to change screen with index
  onTapFunction(int index, VoidCallback onTap,{bool permission=true}) {
    if(permission) {
      screenIndex = index;
      if (screenType(context) == ScreenType.desktop) {
        setState(() {});
      } else {
        onTap();
      }
    }
  }

  @override
  void initState() {
    super.initState();
   userProvider=Provider.of<UserProvider>(context, listen: false);
   userProvider.deviceAuthority;
    windowManager.addListener(this);
    _init();
  }
  void _init() async {
    // Add this line to override the default close handler
    await windowManager.setPreventClose(true);
    setState(() {});
  }
  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      showDialog(context: context, builder: (_)=>CustomAlert(
        title: "آیا از بستن برنامه مطمئن هستید؟",
        onYes: () async {
          if(userProvider.saveBackupOnExist) {
            await BackupTools(quickBackup: true).createBackup(context,directory: userProvider.backupDirectory,);
          }
          Navigator.of(context).pop();
          await windowManager.destroy();
        },
      )
      );
    }
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop)async{
      if(userProvider.saveBackupOnExist) {
        await BackupTools(quickBackup: true).createBackup(
          context, directory: userProvider.backupDirectory,);
      }
      },
      child: Scaffold(
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
              const Gap(5),
              Flexible(child: Text("HITOP CAFE ",style: GoogleFonts.aBeeZee(fontSize: 23,color: Colors.black),)),
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
        body: DoubleBackToCloseApp(
      snackBar: const SnackBar(
      content: Text('برای خروج دوباره ضربه بزنید'),),
          child: Container(
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.topCenter,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                            color: Colors.white),
                        child: screens[screenIndex],
                      ),
                    ),
                  ),
                Flexible(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: Column(

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ///home screen header (show time)
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            width: 600,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.all(10),
                            decoration:  BoxDecoration(
                              gradient: kMainGradiant,
                              borderRadius:screenType(context) != ScreenType.mobile?const BorderRadius.horizontal(left: Radius.circular(10)):null,
                            ),
                            child: Center(
                              child: Text(
                                "امروز: ${DateTime.now().toPersianDateStr()}",
                                style: const TextStyle(color: Colors.white, fontSize: 17),
                              ),
                            ),
                          ),
                        ),
                        ///Notification snack
                        (!NoticeTools.checkNewNotifications())
                            ? const SizedBox(height: 10,)
                            :const NoticeCarousel(),
                        ///Note Carousel Slider
                        NoteCarouselSlider(onChange:  ()=>setState(() {})),
                        Container(
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
                                        width: 250,
                                        image: "active-orders.jpg",
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
                                        width: 150,
                                        image: "orders-history.jpg",
                                        onTap: () {
                                          onTapFunction(0, () {
                                            Navigator.pushNamed(
                                                context, OrderScreen.id);
                                          });
                                        }),
                                  ),
                                ],
                              ),
                              ///ware house button raw wares and main items and customers
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: CardButton(
                                      label: "مشتری ها",
                                      width: 134,
                                      height: 208,
                                      image: "customers-v.jpg",
                                      onTap: () {
                                        onTapFunction(
                                          6,
                                              () {
                                            Navigator.pushNamed(
                                                context, CustomerListScreen.id);
                                          },
                                        );
                                      },
                                      verticalDirection: true,

                                    ),
                                  ),
                                  ///items and rows
                                  Flexible(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ///items
                                        CardButton(
                                            label: "لیست آیتم ها ",
                                            width: 250,
                                            height: 100,
                                            image: "items.jpg",
                                            verticalDirection: false,
                                            onTap: () {
                                              onTapFunction(2, () {
                                                Navigator.pushNamed(context, ItemsScreen.id);
                                              });
                                            }),
                                        ///raw wares
                                        CardButton(
                                            label: "لیست مواد خام ",
                                            width: 250,
                                            height: 100,
                                            image: "raw-wares.jpg",
                                            verticalDirection: false,
                                            onTap: () {
                                              onTapFunction(3, () {
                                                Navigator.pushNamed(
                                                    context, WareListScreen.id);
                                              });
                                            }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              ///circle buttons
                            ],
                          )),
                        ),
                        ///circle buttons
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SmallCardButton(
                                    label: "هزینه و درآمد فرعی",
                                    image: "expense.png",
                                    onTap: () {
                                      onTapFunction(7, () {
                                        Navigator.pushNamed(
                                            context, OtherExpensesScreen.id);
                                      },permission: UserTools.userPermission(context,userTypes: kupBillScreen));
                                    }),
                                SmallCardButton(
                                    label: "فاکتور خرید",
                                    image: "bill.png",
                                    onTap: () {
                                      onTapFunction(4, () {
                                        Navigator.pushNamed(
                                            context, ShoppingBillScreen.id);
                                      },permission: UserTools.userPermission(context,userTypes: kupBillScreen));
                                    }),
                                SmallCardButton(
                                    label: "آنالیز",
                                    image: "analytics3.png",
                                    onTap: () {
                                      onTapFunction(5, () {
                                        Navigator.pushNamed(
                                            context, AnalyticsScreen.id);
                                      },permission: UserTools.userPermission(context,userTypes: kupAnalyticsScreen));
                                    }),
                              ],
                            ),
                          ),
                        ),
                        const Gap(100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

