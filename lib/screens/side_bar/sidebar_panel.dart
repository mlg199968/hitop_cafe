// ignore_for_file: camel_case_types

import 'dart:io';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/screens/side_bar/purchase_app/authority_screen.dart';
import 'package:hitop_cafe/screens/side_bar/purchase_app/purchase_app_screen.dart';
import 'package:hitop_cafe/screens/side_bar/setting/setting_screen.dart';
import 'package:hitop_cafe/screens/side_bar/shop_info/shop_info_screen.dart';
import 'package:provider/provider.dart';

class SideBarPanel extends StatelessWidget {
  const SideBarPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Consumer<UserProvider>(
        builder: (context,userProvider,child) {
          return Container(
            margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 3),
            child: BlurryContainer(
              color: Colors.white70.withOpacity(.4),
              blur: 5,
              elevation: 10,
              padding: const EdgeInsets.all(0),
              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20),topRight: Radius.circular(10)) ,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ///top info part
                  Stack(
                      children: [
                    Container(
                      height: 150,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/photo3.jpg'),
                              fit: BoxFit.fitWidth,
                              opacity: .6)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back,size: 30,)),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0).copyWith(top: 40),
                        child: Text(
                          userProvider.shopName,
                          style: const TextStyle(color: Colors.white, fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const AvatarHolder()
                  ]),
                  Column(
                    children: [
                      menu_button(
                        text: "مشخصات فروشگاه",
                        icon: Icons.factory,
                        onPress: () {
                          Navigator.pushNamed(context, ShopInfoScreen.id);
                        },
                      ),
                      menu_button(
                        text: "تنظیمات",
                        icon: Icons.settings_outlined,
                        onPress: () {
                          Navigator.pushNamed(context, SettingScreen.id);
                        },
                      ),
                      menu_button(
                        onPress: () {
                          urlLauncher(context: context, urlTarget: "http://mlggrand.ir");
                        },
                        text: "ارتباط با ما",
                        icon: Icons.support_agent_outlined,
                      ),
                      const SizedBox(height: 20,),

                      userProvider.userLevel==0?const PurchaseButton():const SizedBox(),
                    ],
                  ),

                  ///links
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/images/mlggrand.png',
                          width: 110,
                        ),
                        IconButton(
                            onPressed: () {
                              urlLauncher(context: context,urlTarget: 'https://instagram.com/mlg_grand?igshid=YmMyMTA2M2Y=');
                            },
                            icon: const Icon(
                              FontAwesomeIcons.instagram,
                              color: Colors.white,
                              size: 25,
                            )),
                        IconButton(
                            onPressed: () {
                              urlLauncher(context: context, urlTarget: "http://t.me/mlg_grand");
                            },
                            icon: const Icon(
                              FontAwesomeIcons.telegram,
                              color: Colors.white,
                              size: 25,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}

class AvatarHolder extends StatelessWidget {
  const AvatarHolder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String? logo = Provider.of<UserProvider>(context, listen: false).logoImage;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Align(
        heightFactor: 1.7,
        alignment: Alignment.bottomCenter,
        child: CircleAvatar(
          backgroundColor: Colors.white70,
          radius: 50,
          child: CircleAvatar(
            backgroundColor: kMainColor,
            foregroundImage: logo != null
                ? FileImage(
                    File(logo),
                  )
                : null,
            radius: 48,
            child: logo != null
                ? null
                : Image.asset(
              'assets/icons/hitop-white.png',
              height: 60,
            ),
          ),
        ),
      ),
    );
  }
}



class PurchaseButton extends StatelessWidget {
  const PurchaseButton({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, AuthorityScreen.id);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Colors.yellow, Colors.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(blurRadius: 2,color: Colors.grey,offset: Offset(1, 1))
            ]
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("خرید نسخه کامل"),
            SizedBox(
              width: 8,
            ),
            Icon(
              FontAwesomeIcons.crown,
              color: Colors.yellowAccent,
            ),
          ],
        ),
      ),
    );
  }
}



class menu_button extends StatelessWidget {
  const menu_button(
      {super.key, required this.text, required this.onPress, this.icon});
  final String text;
  final IconData? icon;
  final VoidCallback onPress;
  @override
  Widget build(BuildContext context) {
    //decelerations
    Color textColor = Colors.black.withOpacity(.7);
    Color borderColor = kMainColor;
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.4),
          border: Border(
            bottom: BorderSide(
              width: 2,
              color: borderColor,
            ),
            left: BorderSide(
              width: 5,
              color: textColor,
            ),
          ),
        ),
        child: TextButtonTheme(
          data: const TextButtonThemeData(
            style: ButtonStyle(
              alignment: Alignment.centerRight,
              padding: MaterialStatePropertyAll(EdgeInsets.all(0)),
            ),
          ),
          child: TextButton(
              onPressed: onPress,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    text,
                    style: TextStyle(fontSize: 18, color: textColor),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                      child:
                          icon == null ? null : Icon(icon, color: textColor)),
                ],
              )),
        ));
  }
}
