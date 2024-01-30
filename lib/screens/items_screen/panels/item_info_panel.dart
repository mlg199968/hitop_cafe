import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/custom_alert_dialog.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/error_handler.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/screens/items_screen/add_item_screen.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/widgets/info_panel_row.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class ItemInfoPanel {
  ItemInfoPanel(this.context, {required this.item});
  final BuildContext context;
  final Item item;

  List<Widget> get _infoLines => [
        InfoPanelRow(title: "نام کالا", infoList: item.itemName),
        InfoPanelRow(title: "سرگروه", infoList: item.category),
        InfoPanelRow(title: "قیمت فروش", infoList: addSeparator(item.sale)),
        InfoPanelRow(title: "توضیحات", infoList: item.description),
        InfoPanelRow(
            title: "تاریخ ثبت", infoList: item.createDate.toPersianDateStr()),
        InfoPanelRow(
            title: "تاریخ ویرایش:",
            infoList: item.modifiedDate.toPersianDateStr()),
      ];

  Widget get buttons => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ///delete button
          Flexible(
            child: ActionButton(
                label: "حذف",
                bgColor: Colors.red,
                onPress: () {
                  item.delete();
                  Navigator.pop(context);
                  showSnackBar(context, "کالا مورد نظر حذف شد!",
                      type: SnackType.success);
                },
                icon: Icons.delete),
          ),
          const SizedBox(
            width: 5,
          ),

          ///edit button
          Flexible(
            child: ActionButton(
              label: "ویرایش",
              onPress: () {
                Navigator.pushNamed(context, AddItemScreen.id, arguments: item);
              },
              icon: Icons.drive_file_rename_outline_sharp,
            ),
          ),
        ],
      );

  dialogPanel() {
    return CustomDialog(
      height: MediaQuery.of(context).size.height * .6,
      title: "مشخصات کالا",
      image: item.imagePath,
      child: Column(
        children: [
          Expanded(
            child: ListView(children: _infoLines),
          ),
          const SizedBox(
            height: 20,
          ),
          buttons
        ],
      ),
    );
  }

  staticPanel({required VoidCallback onReload}) {
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
            if(item.imagePath!=null)
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: item.imagePath==null?null:DecorationImage(image: FileImage(File(item.imagePath!)),fit:BoxFit.cover,onError:(e,trace){
                  ErrorHandler.errorManger(context, e,route: trace.toString(),title: "ItemImage InfoPanelDesktop show error",);
                } ),
              ),
            ),
            Gap(20),
            Expanded(
              child: ListView(children: _infoLines),
            ),
            const SizedBox(
              height: 20,
            ),
            buttons
          ],
        ),
      ),
    );
  }
}
