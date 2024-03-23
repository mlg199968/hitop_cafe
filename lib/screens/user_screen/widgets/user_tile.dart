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
      this.color = kMainColor,
      required this.onSee});

  final User userDetail;
  final bool enabled;
  final bool selected;
  final VoidCallback onSee;
  final double height;
  final Color color;
  @override
  Widget build(BuildContext context) {
    double radius=selected ? 30 : 20;
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: InkWell(
          onTap: onSee,
          child: SizedBox(
            width: 400,
            child: Card(

              shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: selected ? kSecondaryColor : Colors.black38,
                    width: 2),
                borderRadius: BorderRadius.circular(radius),
              ),
              surfaceTintColor: Colors.white,
              color: Colors.white,
              elevation: 1,
              child: Row(
                children: [
                  ///avatar holder
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        color: kMainColor,
                        borderRadius: BorderRadius.horizontal(right:Radius.circular(radius),left:const Radius.circular(5) ),
                        image: userDetail.image == null
                            ? null
                            : DecorationImage(
                                image: FileImage(File(userDetail.image!)),
                          fit: BoxFit.cover
                              ),
                    ),
                    child: userDetail.image != null
                        ? null
                        : const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(userDetail.name),
                              Text(
                                UserType().englishToPersian(userDetail.userType),
                                style: const TextStyle(color: kMainColor2),
                              ),
                            ],
                          ),

                          ///left side data
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userDetail.createDate.toPersianDate(),
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.black26),
                              ),
                              Text(
                                userDetail.phone ?? "",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black38),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (userProvider.activeUser?.userId ==
                      userDetail.userId)
                  Container(
                    margin: const EdgeInsets.all(5),
                    width: 10,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(radius),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}



class CardListTile extends StatelessWidget {
  CardListTile({super.key,
    required this.enable,
    required this.title,
    required this.topTrailing,
    required this.trailing,
    required this.onTap,
    required this.selected,
    // this.leadingIcon,
    // this.type,
    // this.subTitle,
    // this.topTrailingLabel,
    required this.bottomLeading,
  });

  final bool enable;
  final bool selected;
  final String title;
  // final IconData? leadingIcon;
  // final String? type;
  // final String? subTitle;
  // final String? topTrailingLabel;
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
                // Text(type ?? ""),
                RichText(
                  text: TextSpan(
                    // text: topTrailingLabel ?? "",
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
                text: "",
                style: TextStyle(
                    color: selected ? Colors.blue : Colors.black54,
                    fontSize: 11),
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
