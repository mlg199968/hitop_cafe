import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/custom_float_action_button.dart';
import 'package:hitop_cafe/constants/consts_class.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/error_handler.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/user.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/screens/items_screen/widgets/item_image_holder.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../common/widgets/custom_textfield.dart';
import '../../constants/constants.dart';

class AddCustomerScreen extends StatefulWidget {
  static const String id = "/addCustomerScreen";
  const AddCustomerScreen({super.key, this.oldCustomer});
  final User? oldCustomer;

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  FocusNode firstNameFocus = FocusNode();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController phoneNumberController2 = TextEditingController();
  TextEditingController nickNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String? imagePath;

  ///save bill on local storage
  void saveCustomerOnLocalStorage({String? id}) async {
    try {
      User customerHive = User()
        ..name = firstNameController.text
        ..lastName = lastNameController.text
        ..phone = phoneNumberController.text
        ..phoneNumbers = phoneNumberController2.text.isEmpty
            ? null
            : [phoneNumberController2.text]
        ..nickName =
            nickNameController.text.isEmpty ? "" : nickNameController.text
        ..description =
            descriptionController.text.isEmpty ? "" : descriptionController.text
        ..createDate =
            id != null ? widget.oldCustomer!.createDate : DateTime.now()
        ..modifiedDate = DateTime.now()
        ..score = 10
        ..userId = id ?? const Uuid().v1()
        ..password = ""
        ..userType = UserType.customer
        ..image = id == null ? null : widget.oldCustomer!.image;
      // save image if exist
      if (imagePath != customerHive.image) {
        final String newPath = await Address.customersImage();
        customerHive.image =
            await saveImage(imagePath, customerHive.userId, newPath);
      }

      HiveBoxes.getCustomers().put(customerHive.userId, customerHive);
    } catch (e) {
      ErrorHandler.errorManger(context, e,
          title: "خطا در ذخیره سازی کاربر مشتری",
          route: "AddCustomerScreen saveCustomerOnLocalStorage error ");
    }
  }

  void replaceOldCustomer() {
    if (widget.oldCustomer != null) {
      firstNameController.text = widget.oldCustomer!.name;
      lastNameController.text = widget.oldCustomer!.lastName ?? "";
      phoneNumberController.text = widget.oldCustomer!.phone ?? "";
      phoneNumberController2.text = widget.oldCustomer!.phoneNumbers?.first ?? "";
      nickNameController.text = widget.oldCustomer!.nickName ?? "";
      descriptionController.text = widget.oldCustomer!.description ?? "";
      imagePath = widget.oldCustomer!.image;
    }
  }

  @override
  void initState() {
    replaceOldCustomer();
    firstNameFocus.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    firstNameController;
    lastNameController;
    phoneNumberController;
    phoneNumberController2;
    nickNameController;
    descriptionController;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = screenType(context) == ScreenType.mobile;
    return Scaffold(
      floatingActionButtonLocation:
          isMobile ? null : FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomFloatActionButton(
          label: "ذخیره کردن",
          icon: Icons.save_rounded,
          iconSize: 35,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              if (widget.oldCustomer == null) {
                if (HiveBoxes.getCustomers().values.length <
                    Provider.of<UserProvider>(context, listen: false)
                        .ceilCount) {
                  saveCustomerOnLocalStorage();
                  firstNameController.clear();
                  lastNameController.clear();
                  nickNameController.clear();
                  phoneNumberController.clear();
                  phoneNumberController2.clear();
                  descriptionController.clear();
                  showSnackBar(context, "مشتری به لیست افزوده شد!",
                      type: SnackType.success);
                  FocusScope.of(context).requestFocus(firstNameFocus);
                  setState(() {});
                  // Navigator.pop(context, false);
                } else {
                  showSnackBar(context, Provider.of<UserProvider>(context, listen: false)
                      .ceilCountMessage,
                      type: SnackType.error);
                }
              } else {
                saveCustomerOnLocalStorage(id: widget.oldCustomer!.userId);
                Navigator.pop(context, false);
              }
            }
          }),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: widget.oldCustomer != null
            ? const Text("ویرایش مشتری")
            : const Text("افزودن مشتری"),
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: kMainGradiant,
        ),
        child: SingleChildScrollView(
          child: Container(
            width: 550,
            margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 5)
                .copyWith(top: 60),
            decoration: BoxDecoration(
                gradient: kBlackWhiteGradiant,
                borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ///photo part
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      height: 150,
                      margin: const EdgeInsets.all(5),
                      child: ItemImageHolder(
                        imagePath: imagePath,
                        onSet: (path) {
                          imagePath = path;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  const Gap(20),
                  CustomTextField(
                      label: "نام",
                      controller: firstNameController,
                      focus: firstNameFocus,
                      validate: true),
                  const Gap(10),
                  CustomTextField(
                      label: "نام خانوادگی", controller: lastNameController),
                  const Gap(10),
                  CustomTextField(
                      label: "نام مستعار", controller: nickNameController),
                  const Gap(40),

                  ///phones number part
                  CustomTextField(
                    label: "شماره تلفن اول",
                    controller: phoneNumberController,
                    textFormat: TextFormatter.number,
                  ),
                  const Gap(10),
                  CustomTextField(
                    label: "شماره تلفن دوم",
                    controller: phoneNumberController2,
                    textFormat: TextFormatter.number,
                  ),

                  const Gap(40),
                  CustomTextField(
                    label: "توضیحات",
                    controller: descriptionController,
                    maxLength: 120,
                    maxLine: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
