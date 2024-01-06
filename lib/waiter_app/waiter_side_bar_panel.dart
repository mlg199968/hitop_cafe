// ignore_for_file: camel_case_types

import 'dart:io';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/consts_class.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/user.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/screens/side_bar/notice_screen/notice_screen.dart';
import 'package:hitop_cafe/screens/side_bar/setting/setting_screen.dart';
import 'package:hitop_cafe/screens/side_bar/sidebar_panel.dart';
import 'package:hitop_cafe/screens/user_screen/add_user_screen.dart';
import 'package:hitop_cafe/screens/user_screen/services/user_tools.dart';
import 'package:hitop_cafe/waiter_app/waiter_app_setting_screen.dart';
import 'package:provider/provider.dart';

class WaiterSideBarPanel extends StatelessWidget {
  const WaiterSideBarPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Consumer<UserProvider>(builder: (context, userProvider, child) {
        return Container(
          margin:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 3),
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
                            image: AssetImage('assets/images/photo2.jpg'),
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
                      child: CText(
                        userProvider.activeUser?.name ?? "کاربر نامشخص",
                        color: Colors.white, fontSize: 20,
                      ),
                    ),
                  ),
                  const AvatarHolder()
                ]),
                Column(
                  children: [
                    menu_button(
                      text: "کاربر",
                      icon: Icons.person,
                      onPress: () {
                        User? currentUser =
                            Provider.of<UserProvider>(context, listen: false)
                                .activeUser;
                        if (UserType.waiter != currentUser?.userType) {
                          currentUser = null;
                        }
                        Navigator.pushNamed(context, AddUserScreen.id,
                            arguments: currentUser);
                      },
                    ),
                    menu_button(
                      text: "تنظیمات",
                      icon: Icons.settings_outlined,
                      onPress: () {
                        Navigator.pushNamed(context, WaiterAppSettingScreen.id);
                      }
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
    String? logo = Provider.of<UserProvider>(context, listen: false).activeUser?.image;
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



