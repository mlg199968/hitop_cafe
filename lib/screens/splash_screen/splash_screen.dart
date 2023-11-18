import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/screens/home_screen/home_screen.dart';
import 'package:provider/provider.dart';


class SplashScreen extends StatelessWidget {
  static const String id = '/splash-screen';
   const SplashScreen({Key? key}) : super(key: key);
 // final Future<SharedPreferences> prefs=SharedPreferences.getInstance();
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      Timer(const Duration(milliseconds:1000 ), () async{
      //get user level
      if(context.mounted) {
        Provider.of<UserProvider>(context,listen: false).getUserLevel();
      }
        if(context.mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.id,(context)=>false);
        }



    }); });


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
