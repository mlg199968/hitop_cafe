import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/global.dart';
import 'package:hitop_cafe/models/user.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/providers/ware_provider.dart';
import 'package:hitop_cafe/screens/home_screen/home_screen.dart';
import 'package:hitop_cafe/screens/user_screen/choose_user_screen.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:hitop_cafe/waiter_app/choose_app_type_screen.dart';
import 'package:hitop_cafe/waiter_app/waiter_home_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';


class SplashScreen extends StatefulWidget {
  static const String id = '/splash-screen';
   const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late UserProvider userProvider;
  late Future globalTask;
  @override
  void initState() {
userProvider=Provider.of<UserProvider>(context,listen: false);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Provider.of<WareProvider>(context, listen: false).loadCategories();
    super.didChangeDependencies();
  }
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(context) {
    ///conditions for next screen and time to  part
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      ///get start up data
      globalTask= GlobalTask.getInitData(context);
      await globalTask;
      Timer(const Duration(milliseconds:1100), () async{

        // Shop shop = HiveBoxes.getShopInfo().getAt(0)!;
        // userProvider.getData(shop);

      //if user on the choose user screen check the 'remember user' checkBox we go directly to home screen
      String? appType = userProvider.appType;
      User? currentUser = userProvider.activeUser;
      List<User?> users = HiveBoxes.getUsers().values.toList();
      if(appType==AppType.main.value) {
        if (currentUser != null || users.isEmpty) {
            Navigator.pushReplacementNamed(context, HomeScreen.id);
        }
        else {
            Navigator.of(context).pushNamedAndRemoveUntil(
                ChooseUserScreen.id, (context) => false);
        }
      }
      else if(appType==AppType.waiter.value){
        Navigator.pushReplacementNamed(context, WaiterHomeScreen.id);
      }
      else{
        Navigator.pushNamedAndRemoveUntil(context, AppTypeScreen.id,(context)=>false);
      }
      });
    });

///splash screen ui part
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            gradient: kMainGradiant),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment:MainAxisAlignment.center ,
                children: [
                  const SizedBox(height: 50,),
                  Image.asset('assets/icons/hitop-white.png',width: 120,),
                  const SizedBox(height: 40,),
                  Image.asset('assets/icons/hitop-text.png',width: 100,),

                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Image.asset('assets/icons/mlggrand.png',width: 100,),
            ),
            FutureBuilder(
                future:PackageInfo.fromPlatform() ,
                builder: (context,futureInfo) {

                  String appVersion=(futureInfo.data?.version ??"");
                  String appName=(futureInfo.data?.appName ??"");
                  return Text("$appName $appVersion",style: const TextStyle(color: Colors.white70,fontSize: 15,shadows: [kShadow]),);
                }
            ),
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
