import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/consts_class.dart';
import 'package:hitop_cafe/constants/global.dart';
import 'package:hitop_cafe/models/bug.dart';
import 'package:hitop_cafe/models/database.dart';
import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/models/notice.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/models/pack.dart';
import 'package:hitop_cafe/models/payment.dart';
import 'package:hitop_cafe/models/purchase.dart';
import 'package:hitop_cafe/models/raw_ware.dart';
import 'package:hitop_cafe/models/bill.dart';
import 'package:hitop_cafe/models/shop.dart';
import 'package:hitop_cafe/models/subscription.dart';
import 'package:hitop_cafe/models/user.dart';
import 'package:hitop_cafe/providers/client_provider.dart';
import 'package:hitop_cafe/providers/filter_provider.dart';
import 'package:hitop_cafe/providers/printer_provider.dart';
import 'package:hitop_cafe/providers/setting_provider.dart';
import 'package:hitop_cafe/providers/sever_provider.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/providers/waiter_provider.dart';
import 'package:hitop_cafe/providers/ware_provider.dart';
import 'package:hitop_cafe/router.dart';
import 'package:hitop_cafe/screens/splash_screen/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GlobalTask.init();
  // To turn off landscape mode
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  ///Data base Hive initial
  await Hive.initFlutter();
  //Adaptors
  Hive.registerAdapter(RawWareAdapter());
  Hive.registerAdapter(ItemAdapter());
  Hive.registerAdapter(PaymentAdapter());
  Hive.registerAdapter(BillAdapter());
  Hive.registerAdapter(PurchaseAdapter());
  Hive.registerAdapter(ShopAdapter());
  Hive.registerAdapter(OrderAdapter());
  Hive.registerAdapter(SubscriptionAdapter());
  Hive.registerAdapter(BugAdapter());
  Hive.registerAdapter(NoticeAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(PackAdapter());
  Hive.registerAdapter(DBAdapter());

  //create box for store data
  await Hive.openBox<RawWare>("ware_db",path: await Address.hiveDirectory());
  await Hive.openBox<Item>("item_db",path: await Address.hiveDirectory());
  await Hive.openBox<Order>("order_db",path: await Address.hiveDirectory());
  await Hive.openBox<Bill>("bill_db",path: await Address.hiveDirectory());
  await Hive.openBox<Shop>("shop_db",path: await Address.hiveDirectory());
  await Hive.openBox<Bug>("bug_db",path: await Address.hiveDirectory());
  await Hive.openBox<User>("user_db",path: await Address.hiveDirectory());
  await Hive.openBox<Pack>("pack_db",path: await Address.hiveDirectory());
  await Hive.openBox<Notice>("notice_db",path: await Address.hiveDirectory());

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => WareProvider()),
    ChangeNotifierProvider(create: (context) => UserProvider()),
    ChangeNotifierProvider(create: (context) => FilterProvider()),
    ChangeNotifierProvider(create: (context) => SettingProvider()),
    ChangeNotifierProvider(create: (context) => PrinterProvider()),
    ChangeNotifierProvider(create: (context) => WaiterProvider()),
    ChangeNotifierProvider(create: (context) => ClientProvider()),
    ChangeNotifierProvider(create: (context) => ServerProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    ///set font family
    Provider.of<UserProvider>(context,listen: false).setFontFromHive();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Hitop Cafe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white,
            backgroundColor: kMainColor),
        fontFamily: context.watch<UserProvider>().fontFamily,
        colorScheme: ColorScheme.fromSeed(seedColor: kMainColor),
        useMaterial3: true,
      ),
      onGenerateRoute: (setting) => generateRoute(setting),
      home:  const SplashScreen(),
    );
  }
}
