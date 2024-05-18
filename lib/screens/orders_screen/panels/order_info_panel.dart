import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_dialog.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/screens/orders_screen/add_order_screen.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/widgets/info_panel_row.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

// ignore: must_be_immutable
class OrderInfoPanel extends StatelessWidget {
  OrderInfoPanel(this.infoData, {super.key});
  Order infoData;
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
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: rowInfoList,
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
    );
  }
}

class OrderInfoPanelDesktop extends StatelessWidget {
  const OrderInfoPanelDesktop(
      {required this.infoData, super.key, required this.onDelete});
  final Order infoData;
  final VoidCallback onDelete;

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
    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 5),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                controller: ScrollController(),
                children: rowInfoList
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
                    onDelete();
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
    );
  }
}
