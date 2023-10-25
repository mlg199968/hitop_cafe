import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/models/raw_ware.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/providers/ware_provider.dart';
import 'package:hitop_cafe/router.dart';
import 'package:hitop_cafe/screens/home_screen/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // To turn off landscape mode
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  ///Data base Hive initial
  await Hive.initFlutter();
  //Adaptors
  Hive.registerAdapter(RawWareAdapter());
  Hive.registerAdapter(ItemAdapter());

  //create box for store data
  await Hive.openBox<RawWare>("ware_db");
  await Hive.openBox<Item>("item_db");

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => WareProvider()),
    ChangeNotifierProvider(create: (context) => UserProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: (setting) => generateRoute(setting),
      home: const Directionality(
        textDirection: TextDirection.rtl,
          child: HomeScreen()),
    );
  }
}
