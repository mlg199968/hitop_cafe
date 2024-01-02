import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/consts_class.dart';
import 'package:hitop_cafe/models/user.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:provider/provider.dart';

class UserTile extends StatelessWidget {
  const UserTile(
      {super.key,
      required this.userDetail,
      this.enabled = true,
      this.selected = false,
      this.height = 100,
      this.color=kMainColor,
      required this.onSee});

  final User userDetail;
  final bool enabled;
  final bool selected;
  final VoidCallback onSee;
  final double height;
  final Color color;
  @override
  Widget build(BuildContext context) {

    return Consumer<UserProvider>(
      builder: (context,userProvider,child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: InkWell(
            onTap: onSee,
            child: SizedBox(
              width: 400,
              child: Card(shape: RoundedRectangleBorder(
                side: BorderSide(color: selected?kSecondaryColor:Colors.black26,width: 2),
                  borderRadius: BorderRadius.circular(selected ?30:20),
              ),
                surfaceTintColor: Colors.white,
                color:Colors.white,
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(

                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: kMainColor,
                        foregroundImage: userDetail.image==null?null:FileImage(File(userDetail.image!)),
                        child: const Icon(Icons.person,color: Colors.white,size: 50,),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(userDetail.name),
                                Text(UserType().englishToPersian(userDetail.userType),style: const TextStyle(color: kMainColor2),),
                              ],
                            ),
                            ///left side data
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if(userProvider.activeUser?.userId==userDetail.userId)
                                  const CircleAvatar(backgroundColor: Colors.teal,radius: 10,),
                                Text(userDetail.createDate.toPersianDate(),style: const TextStyle(fontSize:10,color: Colors.black26),),
                                Text(userDetail.phone ?? "",style: const TextStyle(fontSize:12,color: Colors.black38),),

                              ],
                            ),
                          ],
                        ),
                      ),


                    ],
                  ),
                ),
                ),
            ),
          ),
          );
      }
    );
    }
  }

// _CardListTile(
// enable: true,
// title:userDetail.name,
// leadingIcon: FontAwesomeIcons.user,
// type: userDetail.score.toString().toPersianDigit(),
// subTitle: TimeTools.showHour(userDetail.createDate),
// topTrailingLabel: "تاریخ ایجاد: ",
// topTrailing: userDetail.modifiedDate.toPersianDateStr(),
// trailing: "",
// onTap: (){
// Navigator.pushNamed(context, AddUserScreen.id,arguments:userDetail );
// },
// ),

class _CardListTile extends StatelessWidget {
  _CardListTile({
    required this.enable,
    required this.title,
    required this.topTrailing,
    required this.trailing, required this.onTap, required this.selected, this.leadingIcon, this.type, this.subTitle, this.topTrailingLabel, required this.bottomLeading,
  });

  final bool enable;
  final bool selected;
  final String title;
  final IconData? leadingIcon;
  final String? type;
  final String? subTitle;
  final String? topTrailingLabel;
  final String topTrailing;
  final String trailing;
  final String bottomLeading;
  final VoidCallback onTap;

  final tileGlobalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///top part
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(type ?? ""),
                RichText(
                  text: TextSpan(
                    text: topTrailingLabel ?? "",
                    style: TextStyle(
                        color: selected ? Colors.blue : Colors.black54,
                        fontSize: 11),
                    children: [
                      TextSpan(
                          text: topTrailing,
                          style: TextStyle(
                              color: selected ? Colors.blue : Colors.black54,
                              fontSize: 14,
                              fontFamily: kCustomFont)),
                    ],
                  ),
                ),
              ],
            ),

            ///middle section
            RichText(
              text: TextSpan(
                text:"",
                style: TextStyle(
                    color: selected ? Colors.blue : Colors.black54, fontSize: 11),
                children: [
                  TextSpan(
                      text: title,
                      style: TextStyle(
                          color: selected ? Colors.blue : Colors.black54,
                          fontSize: 16,
                          fontFamily: kCustomFont)),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: AutoSizeText(
                trailing,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
                maxLines: 2,
                // style: kCellStyle,
                minFontSize: 9,
                maxFontSize: 14,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: AutoSizeText(
                      bottomLeading.toPersianDigit(),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      textDirection: TextDirection.ltr,
                      maxLines: 1,
                      style: const TextStyle(color: Colors.white),
                      minFontSize: 25,
                      maxFontSize: 35,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
