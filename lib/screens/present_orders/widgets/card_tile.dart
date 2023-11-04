import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hitop_cafe/common/shape/custom_bg_shape.dart';
import 'package:hitop_cafe/common/time/time.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/screens/orders_screen/add_order_screen.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/widgets/action_button.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class CardTile extends StatelessWidget {
  const CardTile(
      {super.key,
      required this.orderDetail,
      this.enabled = true,
      this.height = 70,
      required this.color,
      required this.onSee});

  final Order orderDetail;
  final bool enabled;
  final VoidCallback onSee;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final String payable = addSeparator(orderDetail.payable);
    // String dueDate = "تعیین نشده";
    // if (orderDetail.dueDate != null || orderDetail.dueDate==DateTime(1999)) {
    //   dueDate = orderDetail.dueDate!.toPersianDate();
    // }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        elevation: 5,
        child: SizedBox(
          width: 170,
          height: 200,
          child: BackgroundClipper(
            height: 500,
            color: color,
            child: MyListTile(
              enable: false,
              title:
                  "سفارش${(orderDetail.billNumber ?? 0).toString().toPersianDigit()}",
              leadingIcon: FontAwesomeIcons.table,
              type: TimeTools.showHour(orderDetail.orderDate),
              subTitle: TimeTools.showHour(orderDetail.orderDate),
              topTrailingLabel: "میز: ",
              topTrailing: orderDetail.tableNumber.toString().toPersianDigit(),
              trailing: orderDetail.payable == 0 ? "تسویه شده" : payable,
              bottomLeading:orderDetail.tableNumber.toString().toPersianDigit(),
              onButton:() {
          Navigator.of(context).pushNamed(AddOrderScreen.id,arguments:orderDetail);
          },
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
    this.bottomLeading="", required this.onButton,
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
  final VoidCallback onButton;

  final tileGlobalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    //TODO: order tile responsive added
    return Container(
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
              ActionButton(
                  label: "تسویه",
                  icon: Icons.credit_score,
                  bgColor: Colors.deepOrangeAccent,
                onPress:onButton,
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
