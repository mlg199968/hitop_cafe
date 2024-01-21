// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_alert_dialog.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/raw_ware.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/add_raw_ware_screen.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:persian_number_utility/persian_number_utility.dart';


import '../widgets/info_panel_row.dart';

class WareInfoPanel{
 WareInfoPanel(this.context,{ required this.wareInfo});
 final BuildContext context;
final RawWare wareInfo;

 List<Widget> get _infoLines => [
  InfoPanelRow(title: "نام کالا", infoList: wareInfo.wareName),
  InfoPanelRow(title: "سرگروه", infoList: wareInfo.category),
  InfoPanelRow(
      title: "قیمت خرید", infoList: addSeparator(wareInfo.cost)),
  InfoPanelRow(
      title: "مقدار", infoList: "${wareInfo.quantity} ${wareInfo.unit} "),
  InfoPanelRow(title: "توضیحات", infoList: wareInfo.description),
  InfoPanelRow(
      title: "تاریخ ثبت", infoList: wareInfo.createDate.toPersianDateStr()),
  InfoPanelRow(
      title: "تاریخ ویرایش:",
      infoList: wareInfo.modifiedDate.toPersianDateStr()),
];

 dialogPanel() {
  return CustomDialog(
    height: MediaQuery
        .of(context)
        .size
        .height * .5,
    title: "مشخصات کالا",
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
                  wareInfo.delete();
                  Navigator.pop(context);
                  showSnackBar(context, "کالا مورد نظر حذف شد!",
                      type: SnackType.success);
                },
                icon: Icons.delete),

            ///edit button
            ActionButton(
              label: "ویرایش",
              onPress: () {
                Navigator.pushNamed(context, AddWareScreen.id,
                    arguments: wareInfo);
              },
              icon: Icons.drive_file_rename_outline_sharp,
            ),
          ],
        ),
      ],
    ),
  );
}


staticPanel(
    {required VoidCallback onReload}) {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: Container(
      width: 300,
      margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 5),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
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
                    wareInfo.delete();
                    onReload();
                    showSnackBar(context, "کالا مورد نظر حذف شد!",
                        type: SnackType.success);
                  },
                  icon: Icons.delete),

              ///edit button
              ActionButton(
                label: "ویرایش",
                onPress: () {
                  Navigator.pushNamed(context, AddWareScreen.id,
                      arguments: wareInfo);
                },
                icon: Icons.drive_file_rename_outline_sharp,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

}
