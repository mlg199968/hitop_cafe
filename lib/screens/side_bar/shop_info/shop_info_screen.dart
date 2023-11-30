import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/common/widgets/hide_keyboard.dart';
import 'package:hitop_cafe/common/widgets/image_picker_holder.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/shop.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:provider/provider.dart';

class ShopInfoScreen extends StatefulWidget {
  static const String id = "/ShopInfoScreen";
  const ShopInfoScreen({Key? key}) : super(key: key);

  @override
  State<ShopInfoScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<ShopInfoScreen> {
  TextEditingController shopNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController phoneNumberController2 = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  File? logoImage;
  File? stampImage;
  File? signatureImage;


void storeInfoShop(){
  Shop shop=Shop()
      ..shopName=shopNameController.text
      ..address=addressController.text
      ..phoneNumber=phoneNumberController.text
      ..phoneNumber2=phoneNumberController2.text
      ..description=descriptionController.text
      ..signatureImage=signatureImage==null?null:signatureImage!.path
      ..stampImage=stampImage==null?null:stampImage!.path
      ..logoImage=logoImage==null?null:logoImage!.path;
  Provider.of<UserProvider>(context,listen: false).getData(shop);
       HiveBoxes.getShopInfo().put(0,shop);
}

void getData(){
  Shop? shopInfo=HiveBoxes.getShopInfo().get(0);
  if(shopInfo!=null){
   shopNameController.text= shopInfo.shopName;
    addressController.text=shopInfo.address;
    phoneNumberController.text=shopInfo.phoneNumber;
    phoneNumberController2.text=shopInfo.phoneNumber2;
    descriptionController.text=shopInfo.description;
    signatureImage=shopInfo.signatureImage==null?null:File(shopInfo.signatureImage!);
    stampImage=shopInfo.stampImage==null?null:File(shopInfo.stampImage!);
    logoImage=shopInfo.logoImage==null?null:File(shopInfo.logoImage!);
  }
}
@override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    shopNameController.dispose();
    phoneNumberController.dispose();
    phoneNumberController2.dispose();
    addressController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyboard(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: kMainGradiant),
          ),
          title: const Text("اطلاعات شرکت/فروشگاه"),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    /// Name Inputs
                    CustomTextField(
                        maxLength: 35,
                        label: "نام شرکت/فروشگاه",
                        controller: shopNameController),

                    const SizedBox(
                      height: 20,
                    ),

                    ///phones number part
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration:
                          kBoxDecoration.copyWith(color: Colors.transparent),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomTextField(
                              textFormat: TextFormatter.number,
                              maxLength: 15,
                              label: "شماره تلفن",
                              controller: phoneNumberController),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                              textFormat: TextFormatter.number,
                              maxLength: 15,
                              label: "شماره تلفن دوم",
                              controller: phoneNumberController2),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10 ,
                    ),
                    CustomTextField(
                        maxLine: 2,
                        maxLength: 120,
                        label: "آدرس",
                        controller: addressController),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      label: "توضیحات",
                      controller: descriptionController,
                      maxLine: 4,
                      maxLength: 120,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ///Choose shop logo part
                          ImagePickerHolder(
                            text: "انتخاب لوگو",
                            imageFile: logoImage,
                            onPress: () async {
                              //for replace the image with another image we need to give null value first then choose another image.
                              logoImage = null;
                              setState(() {});
                              logoImage = await pickFile("shop_logo.png");
                              setState(() {});
                            },
                            onDelete: (){logoImage = null;
                            setState(() {});},
                          ),
                          ///Choose signature part
                          ImagePickerHolder(
                            text: "انتخاب امضا",
                            imageFile: signatureImage,
                            onPress: () async {
                              signatureImage = null;
                              setState(() {});
                              signatureImage = await pickFile("signature.png");
                              setState(() {});
                            },
                            onDelete: (){
                              signatureImage = null;
                              setState(() {});
                            },
                          ),
                          ///Choose stamp part
                          ImagePickerHolder(
                            text: "انتخاب مهر",
                            imageFile: stampImage,
                            onPress: () async {
                              stampImage = null;
                              setState(() {});
                              stampImage = await pickFile("stamp.png");
                              setState(() {});
                            },
                            onDelete: (){stampImage = null;
                            setState(() {});},
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              CustomButton(
                  width: double.infinity,
                  text: "Save",
                  onPressed: () {
                    storeInfoShop();
                    setState(() {});
                    Navigator.of(context).pop();
                    //Navigator.of(context).pushNamedAndRemoveUntil(CustomerListScreen.id,(route)=>route.settings.name ==ShopInfoScreen.id);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}


