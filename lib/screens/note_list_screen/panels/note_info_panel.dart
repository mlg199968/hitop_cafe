

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/common/widgets/custom_alert_dialog.dart';
import 'package:hitop_cafe/models/note.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/widgets/info_panel_row.dart';
import 'package:persian_number_utility/persian_number_utility.dart';


noteInfoPanel({required BuildContext context, required Note note}) {
  return CustomDialog(
    height: 350,
    title: "یادداشت",
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: ListView(
            children: <Widget>[
              InfoPanelRow(title: "عنوان", infoList: note.title),
              InfoPanelRow(title: "زیرنویس", infoList: note.subTitle),
              InfoPanelRow(
                  title: "تاریخ یادآوری",
                  infoList: note.deadline.toPersianDateStr()),
              InfoPanelRow(
                  title: "تاریخ ثبت",
                  infoList: note.registrationDate.toPersianDateStr()),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ActionButton(
          onPress: () {
            note.delete();
            Navigator.pop(context, "");
          },
          label: "حذف",
          icon: CupertinoIcons.trash,
          bgColor: Colors.red,
        )
      ],
    ),
  );
}

