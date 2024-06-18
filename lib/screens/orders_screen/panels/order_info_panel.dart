import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_dialog.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/screens/orders_screen/add_order_screen.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/widgets/info_panel_row.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/custom_alert.dart';
import '../../../providers/setting_provider.dart';
import '../services/order_tools.dart';


class OrderInfoPanel extends StatelessWidget {
  const OrderInfoPanel(this.infoData, {super.key});
  final Order infoData;
  ///map info
  Map<String, String?> get infoMap => {
    "شماره سفارش":infoData.billNumber.toString().toPersianDigit(),
    "میز":infoData.tableNumber.toString().toPersianDigit(),
    "سفارشات":infoData.items.map((e) => e.itemName).toString(),
    "نام کاربر": infoData.user != null ? infoData.user!.name : "نامشخص",
    "نام مشتری": infoData.customer?.fullName ?? "نامشخص",
    "توضیحات:":infoData.description ?? "",
    "تاریخ تغییر:":infoData.orderDate.toPersianDateStr(),
    "باقی مانده:":addSeparator(infoData.payable),
    "جمع پرداخت کل:":addSeparator(infoData.paymentSum),
    "جمع پرداخت با کارت:":addSeparator(infoData.atmSum),
    "جمع نقد:":addSeparator(infoData.cashSum),
    "جمع کارت به کارت:":addSeparator(infoData.cardSum),
  };
  List<Widget> get rowInfoList => [
        InfoPanelRow(
            title: "شماره سفارش",
            infoList: infoData.billNumber.toString().toPersianDigit()),
        InfoPanelRow(
            title: "میز",
            infoList: infoData.tableNumber.toString().toPersianDigit()),
        InfoPanelRow(
            title: "نام کاربر",
            infoList: infoData.user != null ? infoData.user!.name : "نامشخص"),
        InfoPanelRow(title: "توضیحات:", infoList: infoData.description ?? ""),
        InfoPanelRow(
            title: "تاریخ تغییر:",
            infoList: infoData.orderDate.toPersianDateStr()),
        InfoPanelRow(
            title: "باقی مانده:", infoList: addSeparator(infoData.payable)),
        InfoPanelRow(
            title: "جمع پرداخت با کارت:",
            infoList: addSeparator(infoData.atmSum)),
        InfoPanelRow(
            title: "جمع نقد:", infoList: addSeparator(infoData.cashSum)),
        const SizedBox(
          height: 20,
        ),
      ];
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      height: MediaQuery.of(context).size.height * .6,
      title: "مشخصات سفارش",
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(
                  infoMap.length,
                      (index) => InfoPanelRow(
                      title: infoMap.keys.elementAt(index),
                      infoList: infoMap.values.elementAt(index)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ActionButton(
                    label: "حذف",
                    bgColor: Colors.red,
                    onPress: () async {
                      //delete();
                      infoData.delete();
                      Navigator.pop(context);
                    },
                    icon: Icons.delete,
                  ),
                  ActionButton(
                    label: "ویرایش",
                    icon: Icons.drive_file_rename_outline_sharp,
                    onPress: () {
                      Navigator.pushNamed(context, AddOrderScreen.id,
                          arguments: infoData);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderInfoPanelDesktop extends StatelessWidget {
  const OrderInfoPanelDesktop(
      {required this.infoData, super.key, required this.onDelete});
  final Order infoData;
  final VoidCallback onDelete;
  Map<String, String?> get infoMap =>OrderInfoPanel(infoData).infoMap;

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingProvider>(
        builder: (context,settingProvider,child) {
        return Container(
          width: 500,
          margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 5),
          decoration: BoxDecoration(
              color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [kShadow]
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(
                          infoMap.length,
                              (index) => InfoPanelRow(
                              title: infoMap.keys.elementAt(index),
                              infoList: infoMap.values.elementAt(index)),
                        ),
                      ),
                    ),
                  ),
                ),
                ///buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ActionButton(
                      label: "حذف",
                      borderRadius: 5,
                      bgColor: Colors.black87,
                      iconColor: Colors.red,
                      onPress: () async {
                        await showDialog(
                            context: context,
                            builder: (context) => CustomAlert(
                                title: "آیا از حدف این سفارش مطمئن هستید؟ ",
                                onYes: () {
                                  if(settingProvider.doStorageChange){
                                    OrderTools.addToWareStorage(infoData.items);
                                  }
                                  infoData.delete();
                                  Navigator.pop(context);
                                  onDelete();
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
                      icon: Icons.delete,
                    ),
                    ActionButton(
                      label: "ویرایش",
                      borderRadius: 5,
                      icon: Icons.drive_file_rename_outline_sharp,
                      iconColor: Colors.amber,
                      bgColor: Colors.black87,
                      onPress: () {
                        Navigator.pushNamed(context, AddOrderScreen.id,
                            arguments: infoData);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
