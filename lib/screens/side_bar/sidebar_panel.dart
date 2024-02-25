// ignore_for_file: camel_case_types

import 'dart:io';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/consts_class.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/screens/side_bar/notice_screen/notice_screen.dart';
import 'package:hitop_cafe/screens/side_bar/purchase_app/authority_screen.dart';
import 'package:hitop_cafe/screens/side_bar/purchase_app/purchase_app_screen.dart';
import 'package:hitop_cafe/screens/side_bar/setting/setting_screen.dart';
import 'package:hitop_cafe/screens/side_bar/shop_info/shop_info_screen.dart';
import 'package:hitop_cafe/screens/user_screen/services/user_tools.dart';
import 'package:hitop_cafe/screens/user_screen/user_list_screen.dart';
import 'package:provider/provider.dart';

class SideBarPanel extends StatelessWidget {
  const SideBarPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Consumer<UserProvider>(builder: (context, userProvider, child) {
        return Container(
          margin:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height*.3),
          child: BlurryContainer(
            color: Colors.white70.withOpacity(.4),
            blur: 5,
            elevation: 10,
            padding: const EdgeInsets.all(0),
            borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(20),
                topRight: Radius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ///top info part
                Stack(children: [
                  ///top background
                  Container(
                    height: 150,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/photo3.jpg'),
                            fit: BoxFit.fitWidth,
                            opacity: .6)),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const BackButton(
                          color: Colors.white70,
                        ),
                        ///Notification icon button
                        IconButton(
                            color: Colors.white,
                            onPressed: () {
                              Navigator.pushNamed(context, NoticeScreen.id);
                            },
                            icon: const Icon(Icons.notifications,size: 25,))
                      ],
                    ),
                  ),
                  ///cafe name
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0).copyWith(top: 40),
                      child: Text(
                        userProvider.shopName,
                        style:
                        const TextStyle(color: Colors.white, fontSize: 20),
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
                      icon: Icons.storefront_outlined,
                      onPress: () {
                        if(UserTools.userPermission(context,userTypes: [])) {
                          Navigator.pushNamed(context, ShopInfoScreen.id);}
                      },
                    ),
                    menu_button(
                      text: "کاربران",
                      icon: Icons.person_outlined,
                      onPress: () {
                        if(UserTools.userPermission(context,userTypes: [UserType.manager])) {
                          Navigator.pushNamed(
                              context, UserListScreen.id);
                        }},
                    ),
                    menu_button(
                      text: "تنظیمات",
                      icon: Icons.settings_outlined,
                      onPress: () {
                        if(UserTools.userPermission(context,userTypes: [UserType.waiter])) {
                          Navigator.pushNamed(context, SettingScreen.id);}
                      },
                    ),
                    menu_button(
                      text: "ارتباط با ما",
                      icon: Icons.support_agent_outlined,
                      onPress: () {
                        urlLauncher(
                            context: context, urlTarget: "http://mlggrand.ir");
                      },

                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    userProvider.level == 0
                        ? const PurchaseButton()
                        : const SizedBox(),

                    ///a button just for test
                    ActionButton(
                      icon: Icons.account_balance_outlined,
                      onPress: () {
                        Navigator.pushNamed(context, PurchaseAppScreen.id,
                            arguments: {"phone": "9306374837"});
                      },
                    ),
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
                            urlLauncher(
                                context: context,
                                urlTarget:
                                'https://instagram.com/mlg_grand?igshid=YmMyMTA2M2Y=');
                          },
                          icon: const Icon(
                            FontAwesomeIcons.instagram,
                            color: Colors.white,
                            size: 25,
                          )),
                      IconButton(
                          onPressed: () {
                            urlLauncher(
                                context: context,
                                urlTarget: "http://t.me/mlg_grand");
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
      }),
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
      onTap: () {
        Navigator.pushNamed(context, AuthorityScreen.id);
      },
      child: Container(
        width: 300,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Colors.yellow, Colors.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(blurRadius: 2, color: Colors.grey, offset: Offset(1, 1))
            ]),
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
      {super.key, required this.text, required this.onPress, this.icon, this.enable=true});
  final String text;
  final bool enable;
  final IconData? icon;
  final VoidCallback onPress;
  @override
  Widget build(BuildContext context) {
    //decelerations
    Color textColor = Colors.black.withOpacity(.7);
    Color borderColor = kMainColor;
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.7),
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
              padding: MaterialStatePropertyAll(EdgeInsets.all(5)),
            ),
          ),
          child: TextButton(
              onPressed:enable? onPress : (){},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CText(
                    text,
                    fontSize: 15, color: textColor,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                      child:
                      icon == null ? null : Icon(icon, color: textColor.withOpacity(.5))),
                ],
              )),
        ));
  }
}
