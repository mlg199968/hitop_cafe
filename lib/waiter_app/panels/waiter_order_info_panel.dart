// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_alert_dialog.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/models/pack.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/widgets/info_panel_row.dart';
import 'package:hitop_cafe/waiter_app/waiter_add_order_screen.dart';
import 'package:persian_number_utility/persian_number_utility.dart';


class WaiterOrderInfoPanel extends StatelessWidget {
  const WaiterOrderInfoPanel({super.key,required this.pack,});

  Order get order=>Order().fromJson(pack.object!.single);
  final Pack pack;


  List<Widget> get _infoLines => [
    InfoPanelRow(title: "شماره سفارش", infoList: order.billNumber.toString().toPersianDigit()),
    InfoPanelRow(title: "میز", infoList: order.tableNumber.toString().toPersianDigit()),
    InfoPanelRow(title: "نام کاربر", infoList: order.user!=null?order.user!.name:"نامشخص"),

    InfoPanelRow(title: "توضیحات", infoList: order.description),
    InfoPanelRow(
        title: "تاریخ ثبت", infoList: order.orderDate.toPersianDateStr()),
    InfoPanelRow(
        title: "تاریخ ویرایش:",
        infoList: order.modifiedDate.toPersianDateStr()),
  InfoPanelRow(
        title: "نوع بسته:",
        infoList: pack.type ?? ""),
  InfoPanelRow(
        title: "پیام بسته:",
        infoList: pack.message ?? ""),
  InfoPanelRow(
        title: "نام دستگاه:",
        infoList: pack.device ?? ""),
  ];
  @override
  Widget build(BuildContext context) {

    return CustomDialog(
      height: MediaQuery
          .of(context)
          .size
          .height * .5,
      title: "مشخصات سفارش",
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: _infoLines,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[

              ///delete button
              ActionButton(
                  label: "حذف",
                  bgColor: Colors.red,
                  onPress: () {
                    pack.delete();
                    //HiveBoxes.getPack().delete(pack.packId);
                    Navigator.pop(context);
                    showSnackBar(context, "کالا مورد نظر حذف شد!",
                        type: SnackType.success);
                  },
                  icon: Icons.delete),

              ///edit button
              ActionButton(
                label: "ویرایش",
                onPress: () {
                  Navigator.pushNamed(context, WaiterAddOrderScreen.id,
                      arguments: order);
                },
                icon: Icons.drive_file_rename_outline_sharp,
              ),
            ],
          ),
        ],
      ),
    );
  }
}


