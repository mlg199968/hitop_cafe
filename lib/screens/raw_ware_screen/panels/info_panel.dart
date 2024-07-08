import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/models/raw_ware.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../common/widgets/action_button.dart';
import '../../../common/widgets/custom_alert.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_dialog.dart';
import '../../../common/widgets/empty_holder.dart';
import '../../../constants/enums.dart';
import '../../../constants/error_handler.dart';
import '../../../constants/utils.dart';
import '../add_raw_ware_screen.dart';
import '../widgets/info_panel_row.dart';

class WareInfoPanel extends StatelessWidget {
  const WareInfoPanel({super.key,required this.ware});
  final RawWare ware;

  Map<String, String?> get infoMap => {
    "نام کالا": ware.wareName,
    "سرگروه": ware.category,
    "قیمت خرید": addSeparator(ware.cost),
    "مقدار": "${ware.quantity} ${ware.unit} ",
    "توضیحات:": ware.description,
    "تاریخ ثبت:": ware.createDate.toPersianDateStr(),
    "تاریخ ویرایش:": ware.modifiedDate.toPersianDateStr(),
  };
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      height: 600,
      contentPadding: EdgeInsets.zero,
      image: ware.imagePath,
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
                      title: "آیا از حذف کالا مورد نظر مطمئن هستید؟",
                      onYes: (){
                        ware.delete();
                        Navigator.pop(context,false);
                        Navigator.pop(context,false);

                        showSnackBar(context, "کالا مورد نظر حذف شد!",
                            type: SnackType.success);
                      },
                      onNo: (){
                        Navigator.pop(context,false);
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
                Navigator.pushNamed(context, AddWareScreen.id,
                    arguments: ware);
              },
              icon: const Icon(Icons.drive_file_rename_outline_sharp,size: 20,
                color: Colors.orangeAccent,),
            ),
          ],
        ),
      ],
      title: "مشخصات کالا",
      child: Column(
        children: [
          Expanded(
            child: ListView(
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
          ),
        ],
      ),
    );
  }
}



class InfoPanelDesktop extends StatelessWidget {
  const InfoPanelDesktop({super.key, required this.ware, required this.onReload});
  final RawWare ware;
  final VoidCallback onReload;
  Map<String, String?> get infoMap =>WareInfoPanel(ware: ware).infoMap;
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
                    if (ware.imagePath != null && ware.imagePath != "")
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          height: 200,
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image(
                              image: FileImage(File(ware.imagePath!)),
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
                          title: "آیا از حذف کالا مورد نظر مطمئن هستید؟",
                          onYes: (){
                            ware.delete();
                            Navigator.pop(context,false);
                            onReload();

                            showSnackBar(context, "کالا مورد نظر حذف شد!",
                                type: SnackType.success);
                          },
                          onNo: (){
                            Navigator.pop(context,false);
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
                    Navigator.pushNamed(context, AddWareScreen.id,
                        arguments: ware);
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

