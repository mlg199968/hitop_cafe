import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/custom_alert.dart';
import 'package:hitop_cafe/common/widgets/custom_dialog.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/empty_holder.dart';
import 'package:hitop_cafe/constants/consts_class.dart';
import 'package:hitop_cafe/models/user.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/widgets/info_panel_row.dart';
import 'package:hitop_cafe/screens/user_screen/add_user_screen.dart';
import 'package:hitop_cafe/screens/user_screen/choose_user_screen.dart';
import 'package:hitop_cafe/waiter_app/choose_app_type_screen.dart';
import 'package:provider/provider.dart';

class ActiveUserPanel extends StatelessWidget {
  const ActiveUserPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      User? user = userProvider.activeUser;
        return CustomDialog(
            height: 320,
            borderRadius: 10,
            title: "کاربر حاضر",
            contentPadding: EdgeInsets.zero,
            ///top button
            topTrail: Flexible(
              child: CustomButton(
                text: "تغییر برنامه",
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: 100,
                height: 30,
                icon: const Icon(Icons.change_circle_outlined),
                radius: 15,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>  CustomAlert(
                        title:
                            "آیا از تغییر نوع برنامه (اصلی به سفارشگیر) مطمئن هستید؟",
                    onNo: (){Navigator.pop(context);},
                    onYes: (){
                      Navigator.pushNamedAndRemoveUntil(context, AppTypeScreen.id,(context)=>false);
                    },
                    ),
                  );
                },
              ),
            ),
            ///actions
            actions: [
              ///logout button
              if (user != null)
              CustomButton(
                text: "خروج کاربر",
                width: 100,
                height: 30,
                icon: const Icon(Icons.logout,color: Colors.white70,),
                color: Colors.red,
                onPressed: () {
                  Provider.of<UserProvider>(context,listen: false).setUser(null);
                  Navigator.pushReplacementNamed(
                      context, ChooseUserScreen.id);
                },
              ),
            ],
            child: SingleChildScrollView(
              child: Consumer<UserProvider>(builder: (context, userProvider, child) {
                User? user = userProvider.activeUser;
                if (user != null) {
                  return Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ///circle avatar
                        CircleAvatar(
                          radius: 50,
                          foregroundImage:
                              user.image == null ? null : FileImage(File(user.image!)),
                          child: user.image != null
                              ? null
                              : const Icon(FontAwesomeIcons.user),
                        ),
                        const Gap(20),
                        InfoPanelRow(infoList: user.name, title: "نام"),
                        InfoPanelRow(
                            infoList: UserType().englishToPersian(user.userType),
                            title: "سمت"),
                        InfoPanelRow(infoList: user.phone ?? "", title: "شماره تماس"),


                      ],
                    ),
                  );

                  ///if there is no user found
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const EmptyHolder(height: 100,text:"حساب کاربری یافت نشد",icon: Icons.no_accounts_rounded,),
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
              }),
            ));
      }
    );
  }
}
