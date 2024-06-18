import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/common/widgets/custom_alert.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_icon_button.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/common/widgets/empty_holder.dart';
import 'package:hitop_cafe/common/widgets/glass_bg.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/error_handler.dart';
import 'package:hitop_cafe/models/user.dart';
import 'package:hitop_cafe/screens/customer_screen/add_customer_screen.dart';
import 'package:hitop_cafe/screens/customer_screen/customer_list_screen.dart';
import 'package:hitop_cafe/screens/orders_screen/widgets/customer_holder.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/widgets/info_panel_row.dart';
import 'package:persian_number_utility/persian_number_utility.dart';



class CustomerInfoPanel extends StatelessWidget {
  const CustomerInfoPanel(this.infoData, {super.key});
  final User infoData;
  ///map info
  Map<String, String?> get infoMap => {
        "نام:": infoData.name,
        "نام خانوادگی:": infoData.lastName,
        "نام مستعار:": infoData.nickName,
        "شماره تلفن اول:": infoData.phone,
        "شماره تلفن دیگر:": infoData.phoneNumbers==null?"":infoData.phoneNumbers.toString(),
        "توضیحات:": infoData.description,
        "تاریخ ثبت:": infoData.createDate.toPersianDateStr(),
        "تاریخ ویرایش:": infoData.modifiedDate.toPersianDateStr(),
        "امتیاز:": infoData.score.toString(),
      };
  String get fullName=>"${infoData.name} ${infoData.lastName ?? ""}";

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons=key==const Key(CustomerInfoHolder.id)
            ?<Widget>[
          ///delete button
          CustomButton(
              width: 100,
              height: 30,
              text: "حذف",
              color: Colors.red,
              onPressed: () async {
                Navigator.pop(context,"delete");
              },
              icon: const Icon(CupertinoIcons.trash_fill,
                size: 20,
                color: Colors.white70,)
          ),
          ///change customer
          CustomButton(
            width: 100,
            height: 30,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            text: "تغییر طرف حساب",
            icon: const Icon(Icons.drive_file_rename_outline_sharp,size: 20,
              color: Colors.orangeAccent,),

            onPressed: () {
              Navigator.pushNamed(context, CustomerListScreen.id,
                  arguments: const Key("addBook"))
                  .then((value) {
                if (value != null) {
                  Navigator.pop(context,value);
                }
              });
            },
          ),
        ]
            :<Widget>[
          CustomButton(
              width: 100,
              height: 30,
              text: "حذف",
              color: Colors.red,
              onPressed: () async {
                showDialog(context: context, builder: (context)=>CustomAlert(
                  title: "آیا از حدف مشتری مطمئن هستید؟",
                  onYes: (){
                    infoData.delete();
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ));
                //delete();

              },
              icon: const Icon(CupertinoIcons.trash_fill,
                size: 20,
                color: Colors.white70,)
          ),
          CustomButton(
            width: 100,
            height: 30,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            text: "ویرایش",
            icon: const Icon(Icons.drive_file_rename_outline_sharp,size: 20,
              color: Colors.orangeAccent,),

            onPressed: () {
              Navigator.pushNamed(context, AddCustomerScreen.id,
                  arguments: infoData);
            },
          ),
        ];
    /// ***** main part *******
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        iconPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.white.withOpacity(0),
        surfaceTintColor: Colors.white,

        buttonPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.all(15),
        actionsPadding: EdgeInsets.zero,
      content: Container(
        height: 600,
        width: 500,
        decoration: BoxDecoration(
            gradient: kBlackWhiteGradiant,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [kShadow]
        ),
        child: Stack(
          children: [
             Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CustomIconButton(
                    icon: CupertinoIcons.clear_fill,
                    iconColor: Colors.red,
                    iconSize: 30,
                    onPress: (){
                      Navigator.pop(context,false);
                    },
                  ),),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ///image holder

                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        ///customer bg image
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: SizedBox(
                              height: 200,
                              child:(infoData.image != null && infoData.image != "")
                                  ? Image(
                                image:  FileImage(File(infoData.image!)),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, trace) {
                                  ErrorHandler.errorManger(context, error,
                                      route: trace.toString(),
                                      title: "InfoPanelDesktop widget load image error");
                                  return const EmptyHolder(
                                      text: "بارگزاری تصویر با مشکل مواجه شده است",
                                      icon: Icons.image_not_supported_outlined);
                                },
                              )
                                  : Image.asset("assets/images/profile.png")
                          ),
                        ),
                        ///blurry layer
                        GlassBackground(
                          sigma: 5,
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                  color:(infoData.image != null && infoData.image != "")?Colors.black26:null,
                                  gradient:(infoData.image != null && infoData.image != "")?null :kMainGradiant
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      CText(fullName,color: Colors.white,fontSize: 16,),
                                      CText(infoData.nickName,color: Colors.white54,fontSize: 14,),
                                    ],
                                  ),
                                  const Gap(5),
                                  ///avatar image holder
                                  Flexible(
                                    child: CircleAvatar(
                                      minRadius: 50,
                                      maxRadius: 60,
                                      foregroundImage:(infoData.image != null && infoData.image != "")?FileImage(File(infoData.image!)):null,
                                      backgroundImage: const AssetImage("assets/images/profile.png"),

                                    ),
                                  )
                                ],
                              ),
                              ///action buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children:buttons
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    ///info list
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
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

                  ],
                ),
              ),
            ),
          ].reversed.toList(),
        ),
      )
    );
  }
}



class CustomerInfoPanelDesktop extends StatelessWidget {
  const CustomerInfoPanelDesktop(
      {required this.infoData, super.key, required this.onDelete});
  final User infoData;
  final VoidCallback onDelete;
  Map<String, String?> get infoMap => CustomerInfoPanel(infoData).infoMap;
  @override
  Widget build(BuildContext context) {
    String fullName="${infoData.name} ${infoData.lastName ?? ""}";
    return Container(
      width: 550,
      margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 5),
      decoration: BoxDecoration(
          gradient: kBlackWhiteGradiant,
          borderRadius: BorderRadius.circular(10),
        boxShadow: const [kShadow]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ///image holder

                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    ///customer bg image
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: SizedBox(
                        height: 200,
                        child:(infoData.image != null && infoData.image != "")
                            ? Image(
                          image:  FileImage(File(infoData.image!)),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, trace) {
                            ErrorHandler.errorManger(context, error,
                                route: trace.toString(),
                                title: "InfoPanelDesktop widget load image error");
                            return const EmptyHolder(
                                text: "بارگزاری تصویر با مشکل مواجه شده است",
                                icon: Icons.image_not_supported_outlined);
                          },
                        )
                            : Image.asset("assets/images/profile.png")
                      ),
                    ),
                    ///blurry layer
                    GlassBackground(
                      sigma: 5,
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color:(infoData.image != null && infoData.image != "")?Colors.black26:null,
                            gradient:(infoData.image != null && infoData.image != "")?null :kMainGradiant
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CText(fullName,color: Colors.white,fontSize: 16,),
                                  CText(infoData.nickName,color: Colors.white54,fontSize: 14,),
                                ],
                              ),
                              const Gap(5),
                              ///avatar image holder
                              Flexible(
                                child: CircleAvatar(
                                  minRadius: 50,
                                  maxRadius: 60,
                                  foregroundImage:(infoData.image != null && infoData.image != "")?FileImage(File(infoData.image!)):null,
                                  backgroundImage: const AssetImage("assets/images/profile.png"),

                                ),
                              )
                            ],
                          ),
                          ///action buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              ActionButton(
                                label: "حذف",
                                bgColor: Colors.red,
                                borderRadius: 5,
                                onPress: () async {
                                  infoData.delete();
                                  onDelete();
                                },
                                icon: Icons.delete,
                              ),
                              ActionButton(
                                label: "ویرایش",
                                borderRadius: 5,
                                icon: Icons.drive_file_rename_outline_sharp,
                                onPress: () {
                                  Navigator.pushNamed(context, AddCustomerScreen.id,
                                      arguments: infoData);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

              ///info list
              Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: List.generate(
                      infoMap.length,
                      (index) => InfoPanelRow(
                          title: infoMap.keys.elementAt(index),
                          infoList: infoMap.values.elementAt(index)),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
