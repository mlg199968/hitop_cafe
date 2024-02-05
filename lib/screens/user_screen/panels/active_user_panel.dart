import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hitop_cafe/common/widgets/custom_alert_dialog.dart';
import 'package:hitop_cafe/constants/consts_class.dart';
import 'package:hitop_cafe/models/user.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/widgets/info_panel_row.dart';
import 'package:hitop_cafe/screens/user_screen/add_user_screen.dart';
import 'package:hitop_cafe/screens/user_screen/choose_user_screen.dart';
import 'package:provider/provider.dart';

class ActiveUserPanel extends StatelessWidget {
  const ActiveUserPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
        height: 320,
        title: "کاربر حاضر",
        child: Consumer<UserProvider>(builder: (context, userProvider, child) {
          User? user = userProvider.activeUser;
          if (user != null) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ///circle avatar
                CircleAvatar(
                  radius: 50,
                  foregroundImage:
                      user.image == null ? null : FileImage(File(user.image!)),
                  child:
                      user.image != null ? null : const Icon(FontAwesomeIcons.user),
                ),
                const SizedBox(height: 20,),
                InfoPanelRow(infoList: user.name, title: "نام"),
                InfoPanelRow(infoList:UserType().englishToPersian(user.userType) , title: "سمت"),
                InfoPanelRow(infoList: user.phone ?? "", title: "شماره تماس"),

                ///logout button
                Flexible(
                  child: ActionButton(
                    label: "خروج کاربر",
                    icon: Icons.logout,
                    bgColor: Colors.red,
                    onPress: () {
                      userProvider.setUser(null);
                      Navigator.pushReplacementNamed(context, ChooseUserScreen.id);
                    },
                  ),
                )
              ],
            );

            ///if there is no user found
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("حسابکاربری یافت نشد"),
                const SizedBox(
                  height: 10,
                ),
                ActionButton(
                  label: "افزودن اکانت ادمین",
                  icon: Icons.person,
                  onPress: () {
                    Navigator.pushNamed(
                      context,
                      AddUserScreen.id,
                    );
                  },
                ),
              ],
            );
          }
        }));
  }
}
