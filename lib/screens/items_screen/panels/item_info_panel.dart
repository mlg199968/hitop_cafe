import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/custom_dialog.dart';
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

import '../../../common/widgets/custom_alert.dart';
import '../../../common/widgets/custom_button.dart';



class ItemInfoPanel extends StatelessWidget {
  const ItemInfoPanel({super.key,required this.item,this.onDelete,});
  final Item item;
  final VoidCallback? onDelete;
  Map<String, String?> get infoMap => {
  "نام کالا":item.itemName,
  "سرگروه": item.category,
  "قیمت فروش": addSeparator(item.sale),
  "مواد تشکیل دهنده":item.ingredients.map((e) => e.wareName).toString(),
  "توضیحات":item.description,
  "تاریخ ثبت":item.createDate.toPersianDateStr(),
  "تاریخ ویرایش:":item.modifiedDate.toPersianDateStr(),
  };

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      height: 500,
      title: "مشخصات آیتم",
      image: item.imagePath,
      actions: [
        Row(
          children: <Widget>[
            ///delete button
            CustomButton(
              text: "حذف",
              icon: const Icon(CupertinoIcons.trash_fill,
                size: 20,
                color: Colors.white70,),
              width: 100,
              height: 30,
              color: Colors.red,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => CustomAlert(
                    title: "آیا از حذف آیتم مورد نظر مطمئن هستید؟",
                    onYes: (){
                        item.delete();
                        onDelete;
                      Navigator.pop(context,false);
                        popFunction(context);
                      showSnackBar(context, "آیتم مورد نظر حذف شد!",
                          type: SnackType.success);
                    },
                  ),
                );
              },
            ),
            const SizedBox(
                width: 10
            ),
            ///edit button
            CustomButton(
              text: "ویرایش",
              width: 100,
              height: 30,
              onPressed: () {
                Navigator.pushNamed(context, AddItemScreen.id, arguments: item);
              },
              icon: const Icon(Icons.drive_file_rename_outline_sharp,size: 20,
                color: Colors.orangeAccent,),
            ),
          ],
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(
          infoMap.length,
              (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: InfoPanelRow(
                title: infoMap.keys.elementAt(index),
                infoList: infoMap.values.elementAt(index)),
          ),
        ),
      ),
    );
  }
}
///
class ItemInfoPanelDesktop extends StatelessWidget {
  const ItemInfoPanelDesktop({super.key,required this.item,required this.onDelete,});
  final Item item;
  final VoidCallback onDelete;
  Map<String, String?> get infoMap =>ItemInfoPanel(item: item).infoMap;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: 550,
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [kShadow]
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (item.imagePath != null && item.imagePath != "")
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          height: 200,
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image(
                              image: FileImage(File(item.imagePath!)),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, trace) {
                                ErrorHandler.errorManger(context, error,
                                    route: trace.toString(),
                                    title: "InfoPanelDesktop widget load image error");
                                return const EmptyHolder(
                                    text: "بارگزاری تصویر با مشکل مواجه شده است",
                                    icon: Icons.image_not_supported_outlined);
                              },
                            ),
                          ),
                        ),
                      ),
                    ///info rows
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Column(
                        children: List.generate(
                          infoMap.length,
                              (index) => InfoPanelRow(
                              title: infoMap.keys.elementAt(index),
                              infoList: infoMap.values.elementAt(index)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            /// buttons
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ///delete button
                ActionButton(
                    label: "حذف",
                    borderRadius: 5,
                    bgColor: Colors.black87,
                    iconColor: Colors.red,
                    onPress: () {
                      showDialog(
                        context: context,
                        builder: (context) => CustomAlert(
                          title: "آیا از حذف آیتم مورد نظر مطمئن هستید؟",
                          onYes: (){
                            item.delete();
                            onDelete();
                            popFunction(context);
                            showSnackBar(context, "آیتم مورد نظر حذف شد!",
                                type: SnackType.success);
                          },
                        ),
                      );

                    },
                    icon: Icons.delete),
                const Gap(10),

                ///edit button
                ActionButton(
                  label: "ویرایش",
                  borderRadius: 5,
                  bgColor: Colors.black87,
                  iconColor: Colors.amber,
                  onPress: () {
                    Navigator.pushNamed(context, AddItemScreen.id, arguments: item);
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

