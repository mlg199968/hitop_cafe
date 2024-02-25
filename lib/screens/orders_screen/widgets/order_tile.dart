import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hitop_cafe/common/shape/background_shape1.dart';
import 'package:hitop_cafe/common/time/time.dart';
import 'package:hitop_cafe/common/widgets/custom_alert.dart';
import 'package:hitop_cafe/common/widgets/custom_tile.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/providers/setting_provider.dart';
import 'package:hitop_cafe/screens/orders_screen/services/order_tools.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:provider/provider.dart';

class OrderTile extends StatelessWidget {
  const OrderTile(
      {super.key,
      required this.orderDetail,
      this.enabled = true,
      this.height = 60,
      required this.color,
      required this.onSee, this.surfaceColor});

  final Order orderDetail;
  final bool enabled;
  final VoidCallback onSee;
  final double height;
  final Color color;
  final Color? surfaceColor;
  @override
  Widget build(BuildContext context) {
    final String payable = addSeparator(orderDetail.payable);
    return Consumer<SettingProvider>(
      builder: (context,settingProvider,child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: ExpandableNotifier(
            child: ScrollOnExpand(
              scrollOnCollapse: false,
              scrollOnExpand: false,
              child: Card(
                elevation: 5,
                surfaceTintColor: surfaceColor ?? Colors.white,
                child: BackgroundShape1(
                  height: height,
                  color: color,
                  child: ExpandablePanel(
                    collapsed: const SizedBox(),
                    expanded: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ///see details button
                        DropButtons(
                            text: "مشاهده",
                            icon: Icons.list_alt,
                            onPress: onSee,
                            color: Colors.indigo),

                          ///delete button
                          DropButtons(
                              text: "حذف",
                              icon: FontAwesomeIcons.trashCan,
                              onPress: () async {
                                await showDialog(
                                    context: context,
                                    builder: (context) => CustomAlert(
                                    title: "آیا از حدف این سفارش مطمئن هستید؟ ",
                                    onYes: () {
                                      if(settingProvider.doStorageChange){
                                        OrderTools.addToWareStorage(orderDetail.items);
                                      }
                                      orderDetail.delete();
                                      Navigator.pop(context);
                                    },
                                    onNo: () {
                                      Navigator.pop(context);
                                    },
                                    extraContent: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Text("اعمال تغییرات در انبار"),
                                        Checkbox(
                                            value: context.watch<SettingProvider>().doStorageChange,
                                            onChanged: (val) {
                                              settingProvider.storageChangeBool(val!);
                                            }),
                                      ],
                                    )));
                              },
                              color: Colors.red),
                        ],
                      ),
                      theme: ExpandableThemeData(
                          iconPadding: EdgeInsets.zero,
                          iconPlacement: ExpandablePanelIconPlacement.left,
                          tapHeaderToExpand: enabled,
                          tapBodyToExpand: enabled,
                          animationDuration: const Duration(milliseconds: 500)),

                      ///main header
                      header: SizedBox(
                        height: height,
                        child: MyListTile(
                          enable: false,
                          title:
                              "سفارش شماره ${(orderDetail.billNumber ?? 0).toString().toPersianDigit()}",
                          leadingIcon: FontAwesomeIcons.table,
                          type: orderDetail.tableNumber.toString().toPersianDigit(),
                          subTitle: TimeTools.showHour(orderDetail.orderDate),
                          topTrailingLabel: "تاریخ سفارش: ",
                          topTrailing: orderDetail.orderDate.toPersianDateStr(),
                          trailing: orderDetail.payable == 0 ? "تسویه شده" : payable,
                        ),
                      ),
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
    return LayoutBuilder(builder: (context, constraint) {
      return Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color,
        ),
        height: 35,
        alignment: Alignment.center,
        child: TextButton(
          onPressed: onPress,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                child: constraint.maxWidth < 120
                    ? null
                    : Text(
                        text,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
