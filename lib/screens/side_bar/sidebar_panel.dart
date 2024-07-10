// ignore_for_file: camel_case_types

import 'dart:io';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/consts_class.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/screens/side_bar/notice_screen/notice_screen.dart';
import 'package:hitop_cafe/screens/side_bar/purchase_app/authority_screen.dart';
import 'package:hitop_cafe/screens/side_bar/purchase_app/plan_screen.dart';
import 'package:hitop_cafe/screens/side_bar/purchase_app/purchase_app_screen.dart';
import 'package:hitop_cafe/screens/side_bar/purchase_app/subscription_screen.dart';
import 'package:hitop_cafe/screens/side_bar/setting/setting_screen.dart';
import 'package:hitop_cafe/screens/side_bar/shop_info/shop_info_screen.dart';
import 'package:hitop_cafe/screens/user_screen/services/user_tools.dart';
import 'package:hitop_cafe/screens/user_screen/user_list_screen.dart';
import 'package:provider/provider.dart';

import 'notice_screen/services/notice_tools.dart';

class SideBarPanel extends StatelessWidget {
  const SideBarPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        height: 600,
        child: Drawer(
          width: 250,
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Consumer<UserProvider>(builder: (context, userProvider, child) {
            return BlurryContainer(
              color: Colors.white70.withOpacity(.4),
              blur: 5,
              elevation: 10,
              padding: const EdgeInsets.all(0),
              borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  topRight: Radius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListView(
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
                        ///buttons
                        const Gap(20),
                        Column(
                          children: [
                            BarButton(
                              text: "مشخصات فروشگاه",
                              icon: Icons.storefront_outlined,
                              onPress: () {
                                if(UserTools.userPermission(context,userTypes: [])) {
                                  Navigator.pushNamed(context, ShopInfoScreen.id);}
                              },
                            ),
                            BarButton(
                              text: "کاربران",
                              icon: Icons.person_outlined,
                              onPress: () {
                                if(UserTools.userPermission(context,userTypes: [UserType.manager])) {
                                  Navigator.pushNamed(
                                      context, UserListScreen.id);
                                }},
                            ),
                            BarButton(
                              text: "اطلاع رسانی ها",
                              active:NoticeTools.checkNewNotifications(),
                              icon: Icons.notifications_active_rounded,
                              onPress: () {
                                Navigator.pushNamed(context, NoticeScreen.id);
                              },
                            ),
                            BarButton(
                              text: "تنظیمات",
                              icon: Icons.settings_outlined,
                              onPress: () {
                                if(UserTools.userPermission(context,userTypes: [UserType.waiter])) {
                                  Navigator.pushNamed(context, SettingScreen.id);}
                              },
                            ),
                            /// contact us
                            Container(
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Column(children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CText(
                                        "ارتباط با ما",
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                      Icon(Icons.support_agent_outlined,color: Colors.white,)
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ///web site icon button
                                      ActionButton(
                                        onPress: () {
                                          urlLauncher(
                                              context: context,
                                              urlTarget:
                                              "http://mlggrand.ir");
                                        },
                                        icon:
                                        Icons.web,
                                        bgColor: Colors.teal,
                                        borderRadius: 5,
                                      ),
                                      ///instagram icon button
                                      ActionButton(
                                        onPress: () {
                                          urlLauncher(
                                              context: context,
                                              urlTarget:
                                              'https://instagram.com/mlg_grand?igshid=YmMyMTA2M2Y=');
                                        },
                                        icon:
                                        FontAwesomeIcons.instagram,
                                        bgColor: Colors.pinkAccent,
                                        borderRadius: 5,
                                      ),
                                      ///telegram
                                      ActionButton(
                                        onPress: () {
                                          urlLauncher(
                                              context: context,
                                              urlTarget: "http://t.me/mlg_grand");
                                        },
                                        icon:
                                        FontAwesomeIcons.telegram,
                                        bgColor: Colors.lightBlueAccent,
                                        borderRadius: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ],),
                            ),

                            const Gap(20),
                            ///Purchase Button when app is level=0
                               const PurchaseButton(),


                            ///a button just for test
                            if(kDebugMode)
                            ActionButton(
                              height: 25,
                              icon: Icons.texture_sharp,
                              onPress: () async{
                                Navigator.pushNamed(context, PlanScreen.id,
                                    // arguments: {"phone": "9910608888","subsId":909}
                                    arguments: {"phone": "9910606073","subsId":939}
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ///mlg grand logo
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0,bottom: 5),
                      child: Image.asset(
                        'assets/icons/mlggrand.png',
                        width: 90,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
///
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
///
class PurchaseButton extends StatelessWidget {
  const PurchaseButton({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context,userProvider,child) {
        return InkWell(
          onTap: () {
            if(userProvider.subscription==null) {
              Navigator.pushNamed(context, AuthorityScreen.id);
            }else{
              Navigator.pushNamed(context, SubscriptionScreen.id);
            }
          },
          child: Container(
            width: 300,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Colors.amber, Colors.orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(blurRadius: 2, color: Colors.grey, offset: Offset(1, 1))
                ]),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CText(userProvider.subscription==null?"خرید نسخه کامل":"وضعیت اشتراک",
                  color: Colors.white,
                ),
                const Gap(8),
                const Icon(
                  FontAwesomeIcons.crown,
                  color: Colors.yellowAccent,
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
///
class BarButton extends StatelessWidget {
  const BarButton(
      {super.key, required this.text, required this.onPress, this.icon, this.enable=true,this.active=false});
  final String text;
  final bool enable;
  final IconData? icon;
  final VoidCallback onPress;
  final bool active;
  @override
  Widget build(BuildContext context) {
    //decelerations
    Color textColor = Colors.white;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8,vertical: 1),
      decoration: BoxDecoration(
        borderRadius:BorderRadius.circular(5),
        // boxShadow: const [BoxShadow(color: Colors.black45,blurRadius: 3,offset: Offset(2, 3))]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          // margin: EdgeInsets.symmetric(horizontal: 8,vertical: 1),
            padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 0),
            decoration:  BoxDecoration(
              color: Colors.black,
              gradient: kMainGradiant2.scale(.7),
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
                      if(active)
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(Icons.circle,
                            size: 15
                            ,color: Colors.red,
                          ),
                        ),
                      const Expanded(child: SizedBox()),
                      CText(
                        text,
                        fontSize: 15, color: textColor,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      if(icon!=null)
                        Icon(icon, color: Colors.amber.withOpacity(.7),size: 20,),
                    ],
                  )),
            )),
      ),
    );
  }
}
