import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hitop_cafe/common/shape/custom_bg_shape.dart';
import 'package:hitop_cafe/common/widgets/custom_alert.dart';
import 'package:hitop_cafe/common/widgets/custom_tile.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class CreditTile extends StatelessWidget {
  const CreditTile(
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
    String dueDate = "تعیین نشده";
    if (orderDetail.dueDate != null || orderDetail.dueDate==DateTime(1999)) {
      dueDate = orderDetail.dueDate!.toPersianDate();
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ExpandableNotifier(
        child: ScrollOnExpand(
          scrollOnCollapse: false,
          scrollOnExpand: false,
          child: Card(
            elevation: 5,
            child: BackgroundClipper(
              height: height,
              color: color,
              child: ExpandablePanel(
                collapsed: const SizedBox(),
                expanded: Row(
                  children: [
                    ///see details button
                    DropButtons(
                        text: "مشاهده",
                        icon: Icons.list_alt,
                        onPress: onSee,
                        color: Colors.blueAccent),

                    ///delete button
                    DropButtons(
                        text: "حذف",
                        icon: FontAwesomeIcons.trashCan,
                        onPress: () async {
                          await customAlert(
                              title: "آیا از حدف این سفارش مطمئن هستید؟ ",
                              context: context,
                              onYes: () {
                                orderDetail.delete();
                                Navigator.pop(context);
                              },
                              onNo: () {
                                Navigator.pop(context);
                              });
                        },
                        color: Colors.red),
                  ],
                ),
                theme:  ExpandableThemeData(
                    iconPadding: const EdgeInsets.all(0),
                    iconPlacement: ExpandablePanelIconPlacement.left,
                    tapHeaderToExpand: enabled,
                    tapBodyToExpand: enabled,
                    animationDuration: const Duration(milliseconds: 500)),

                ///main header
                header: MyListTile(
                  enable: false,
                  title: orderDetail.payable==0?"تسویه شده":"تسویه نشده",
                  leadingIcon: FontAwesomeIcons.table,
                  type: orderDetail.tableNumber.toString().toPersianDigit(),
                  subTitle: orderDetail.orderDate.toPersianDateStr(),
                  topTrailingLabel: "تاریخ تسویه: ",
                  topTrailing: dueDate,
                  trailing: payable,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DropButtons extends StatelessWidget {
  const DropButtons(
      {super.key,
      required this.text,
      required this.icon,
      required this.onPress,
      required this.color});

  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(builder: (context, constraint) {
        return Container(
          alignment: Alignment.center,
          color: color,
          child: TextButton(
            onPressed: onPress,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  icon,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 5,
                ),
                SizedBox(
                  child: constraint.maxWidth < 120
                      ? null
                      : Text(
                          text,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
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
