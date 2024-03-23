import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/custom_alert_dialog.dart';
import 'package:hitop_cafe/common/widgets/empty_holder.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/error_handler.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/screens/items_screen/add_item_screen.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/widgets/info_panel_row.dart';
import 'package:persian_number_utility/persian_number_utility.dart';



class ItemInfoPanel extends StatelessWidget {
  const ItemInfoPanel({super.key,required this.item,this.onDelete,});
  final Item item;
  final VoidCallback? onDelete;
  List<Widget> get _infoLines => [
    InfoPanelRow(title: "نام کالا", infoList: item.itemName),
    InfoPanelRow(title: "سرگروه", infoList: item.category),
    InfoPanelRow(title: "قیمت فروش", infoList: addSeparator(item.sale)),
    InfoPanelRow(title: "مواد تشکیل دهنده", infoList: item.ingredients.map((e) => e.wareName).toString()),
    InfoPanelRow(title: "توضیحات", infoList: item.description),
    InfoPanelRow(
        title: "تاریخ ثبت", infoList: item.createDate.toPersianDateStr()),
    InfoPanelRow(
        title: "تاریخ ویرایش:",
        infoList: item.modifiedDate.toPersianDateStr()),
  ];
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      height: MediaQuery.of(context).size.height * .6,
      title: "مشخصات آیتم",
      image: item.imagePath,
      child: Column(
        children: [
          Expanded(
            child: ListView(children: _infoLines),
          ),
          const SizedBox(
            height: 20,
          ),
          ///buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ///delete button
              Flexible(
                child: ActionButton(
                    label: "حذف",
                    bgColor: Colors.red,
                    onPress: () {
                      item.delete();
                      onDelete;
                      popFunction(context);
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
          )
        ],
      ),
    );
  }
}

class ItemInfoPanelDesktop extends StatelessWidget {
  const ItemInfoPanelDesktop({super.key,required this.item,required this.onDelete,});
  final Item item;
  final VoidCallback onDelete;
  List<Widget> get _infoLines => [
    InfoPanelRow(title: "نام کالا", infoList: item.itemName),
    InfoPanelRow(title: "سرگروه", infoList: item.category),
    InfoPanelRow(title: "قیمت فروش", infoList: addSeparator(item.sale)),
    InfoPanelRow(title: "مواد تشکیل دهنده", infoList: item.ingredients.map((e) => e.wareName).toString()),
    InfoPanelRow(title: "توضیحات", infoList: item.description),
    InfoPanelRow(
        title: "تاریخ ثبت", infoList: item.createDate.toPersianDateStr()),
    InfoPanelRow(
        title: "تاریخ ویرایش:",
        infoList: item.modifiedDate.toPersianDateStr()),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: 550,
        height: 700,
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 5),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20),
          boxShadow: const [kShadow]
        ),
        child: Column(
          children: [
            if(item.imagePath!=null)
              AspectRatio(
                aspectRatio: 16/9,
                child: SizedBox(
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                      image: FileImage(File(item.imagePath!)),
                      fit: BoxFit.cover,
                      errorBuilder: (context,error,trace){
                        ErrorHandler.errorManger(context, error,route: trace.toString(),title: "ItemInfoPanelDesktop widget image load error");
                        return const EmptyHolder(text: "بارگزاری تصویر با مشکل مواجه شده است", icon: Icons.image_not_supported_outlined);
                      },
                    ),
                  ),
                ),
              ),
            const Gap(20),
            Expanded(
              child: ListView(children: _infoLines),
            ),
            const SizedBox(
              height: 20,
            ),
            ///buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ///delete button
                Flexible(
                  child: ActionButton(
                      label: "حذف",
                      bgColor: Colors.red,
                      onPress: () {
                        item.delete();
                        onDelete();
                        popFunction(context);
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
            )
          ],
        ),
      ),
    );
  }
}


