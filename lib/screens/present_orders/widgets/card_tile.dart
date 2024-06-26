import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/shape/background_shape3.dart';
import 'package:hitop_cafe/common/time/time.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class CardTile extends StatelessWidget {
  const CardTile(
      {super.key,
      required this.orderDetail,
      this.enabled = true,
      this.height = 70,
      this.color=kMainColor,
      required this.button, this.selected=false});

  final Order orderDetail;
  final bool enabled;
  final bool selected;
  final Widget button;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final String payable = addSeparator(orderDetail.payable);
    final String ordersName=orderDetail.items.map((e) => e.itemName).toString();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        surfaceTintColor: Colors.white,
        color: Colors.white,
        elevation: 5,
        child: SizedBox(
          width: 400,
          height: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: BackgroundShape3(
              height: 500,
              color: color,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///top part
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(gradient: kMainGradiant,borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(TimeTools.showHour(orderDetail.orderDate),style:const TextStyle(color: Colors.white) ,),
                          RichText(
                            text: TextSpan(
                              text: "سفارش: ",
                              style: TextStyle(
                                  color: selected ? Colors.blue : Colors.white60,
                                  fontSize: 11),
                              children: [
                                TextSpan(
                                    text: orderDetail.billNumber.toString().toPersianDigit(),
                                    style: TextStyle(
                                        color: selected ? Colors.blue : Colors.white,
                                        fontSize: 14,)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    ///middle section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CText(
                            "کاربر: ${orderDetail.user?.name}",
                              color: selected ? Colors.blue : Colors.black54,
                              fontSize: 13,),
                      const Gap(5),
                      CText(
                        orderDetail.payable == 0 ? "تسویه شده" :"مانده: $payable",
                              color: selected ? Colors.blue : Colors.black87,
                              fontSize: 13,maxLine: 1,),
                      ],
                    ),
                    AutoSizeText(
                      ordersName,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      maxLines: 2,
                      // style: kCellStyle,
                      minFontSize: 9,
                      maxFontSize: 13,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: AutoSizeText(
                            orderDetail.tableNumber.toString().toPersianDigit(),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            textDirection: TextDirection.ltr,
                            maxLines: 1,
                            style: const TextStyle(color: Colors.white),
                            minFontSize: 25,
                            maxFontSize: 35,
                          ),
                        ),
                        button,
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyListTile extends StatelessWidget {
  MyListTile({
    super.key,
    required this.enable,
    required this.title,
    this.leadingIcon,
    this.type,
    this.subTitle,
    this.topTrailingLabel,
    required this.topTrailing,
    required this.trailing,
    this.selected = false,
    this.bottomLeading="", required this.button,
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
  final Widget button;

  final tileGlobalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///top part
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(gradient: kMainGradiant,borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(type ?? "",style:const TextStyle(color: Colors.white) ,),
                RichText(
                  text: TextSpan(
                    text: topTrailingLabel ?? "",
                    style: TextStyle(
                        color: selected ? Colors.blue : Colors.white60,
                        fontSize: 11),
                    children: [
                      TextSpan(
                          text: topTrailing,
                          style: TextStyle(
                              color: selected ? Colors.blue : Colors.white,
                              fontSize: 14,
                              fontFamily: kCustomFont)),
                    ],
                  ),
                ),
              ],
            ),
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
              button,
            ],
          ),
        ],
      ),
    );
  }
}
