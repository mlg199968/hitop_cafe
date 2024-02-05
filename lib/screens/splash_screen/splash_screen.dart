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
import 'package:provider/provider.dart';


class SplashScreen extends StatefulWidget {
  static const String id = '/splash-screen';
   const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late UserProvider userProvider;
  @override
  void initState() {
userProvider=Provider.of<UserProvider>(context,listen: false);
    super.initState();
  }
  @override
  Widget build(context) {
    ///conditions for next screen and time to  part
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      Timer(const Duration(milliseconds:1000 ), () async{
        Provider.of<WareProvider>(context, listen: false).loadCategories();
      if(context.mounted) {
        ///get start up data
         GlobalTask.getInitData(context);
        // Shop shop = HiveBoxes.getShopInfo().getAt(0)!;
        // userProvider.getData(shop);
      }
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
        Navigator.pushReplacementNamed(context, AppTypeScreen.id);
      }
      });
    });

///splash screen ui part
    return Container(
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
            child: Image.asset('assets/images/mlggrand.png',width: 100,),
          ),
        ],
      ),
    );
  }
}
