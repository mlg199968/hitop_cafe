import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/common/widgets/drop_list_model.dart';
import 'package:hitop_cafe/common/widgets/hide_keyboard.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/consts_class.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/user.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/screens/items_screen/widgets/item_image_holder.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/screens/user_screen/panels/set_password_panel.dart';
import 'package:hitop_cafe/screens/user_screen/services/user_tools.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddUserScreen extends StatefulWidget {
  static const String id = "/add-user-screen";
  const AddUserScreen({super.key, this.oldUser});
  final User? oldUser;

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  FocusNode firstNameFocus = FocusNode();
  TextEditingController nameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool obscureOldPassword=true;

  String? imagePath;
  String selectedUserType = UserType.waiterPersian;
  late UserProvider userProvider;

  List userTypesList() {
   String? appType= userProvider.appType;

   if(appType==AppType.waiter.value){
      return [UserType.waiterPersian];
    }
   else  if (HiveBoxes.getUsers().values.isEmpty ||
    widget.oldUser?.userType == UserType.admin) {
    selectedUserType = UserType.adminPersian;
    return [UserType.adminPersian];
    }
    else {
      return UserType().getList();
    }
  }

  ///save bill on local storage
  void saveUser({String? id}) async {
    if(UserTools.userPermission(context,userTypes: [UserType.manager]) || userProvider.appType==AppType.waiter.value ) {
      User user = User()
        ..name = nameController.text
        ..userName=userNameController.text
        ..password = passwordController.text
        ..phone =
            phoneNumberController.text.isEmpty ? "" : phoneNumberController.text
        ..email = emailController.text.isEmpty ? "" : emailController.text
        ..description =
            descriptionController.text.isEmpty ? "" : descriptionController.text
        ..createDate = id != null ? widget.oldUser!.createDate : DateTime.now()
        ..modifiedDate = DateTime.now()
        ..score = 10
        ..userType = UserType().persianToEnglish(selectedUserType)
        ..userId = id ?? const Uuid().v1();

      // save image if exist
      if (imagePath != user.image) {
        final String newPath = await Address.profileDirectory();
        user.image = await saveImage(imagePath, user.userId, newPath);
      }else{
        user.image=imagePath;
      }
      HiveBoxes.getUsers().put(user.userId, user);
      if (userProvider.appType==AppType.waiter.value || userProvider.activeUser?.userId==user.userId) {
      userProvider.setUser(user);
      }
    }
  }

  void replaceOldUser() {
    if (widget.oldUser != null) {
      nameController.text = widget.oldUser!.name;
      userNameController.text = widget.oldUser!.userName ?? "";
      phoneNumberController.text = widget.oldUser!.phone ?? "";
      passwordController.text = widget.oldUser!.password;
      emailController.text = widget.oldUser!.email ?? "";
      descriptionController.text = widget.oldUser!.description ?? "";
      imagePath = widget.oldUser!.image;
      selectedUserType = UserType().englishToPersian(widget.oldUser!.userType);
    }
  }

  @override
  void initState() {
    userProvider=Provider.of<UserProvider>(context,listen: false);
    replaceOldUser();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    userNameController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    emailController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyboard(
      child: Consumer<UserProvider>(builder: (context, userProvider, child) {
        return Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(gradient: kMainGradiant),
            ),
            actions: [
              if (widget.oldUser != null &&
                  widget.oldUser?.userType != UserType.admin)
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ActionButton(
                    label: "حذف کاربر",
                    icon: Icons.delete,
                    bgColor: Colors.red,
                    onPress: () {
                      HiveBoxes.getUsers().delete(widget.oldUser!.userId);
                      Navigator.pop(context, false);
                    },
                  ),
                ))
            ],
            title: widget.oldUser != null
                ? const Text("ویرایش کاربر")
                : const Text("افزودن کاربر"),
          ),
          body: Align(
            alignment: Alignment.center,
            child: Container(
              width: 450,
              margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 5),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
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

                        ///photo part
                        Container(
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

                        const SizedBox(
                          height: 20,
                        ),
                        Wrap(
                          textDirection: TextDirection.rtl,
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            const Text("نقش کاربر"),
                            DropListModel(
                                listItem: userTypesList(),
                                selectedValue: selectedUserType,
                                onChanged: (val) {
                                  selectedUserType = val;
                                  setState(() {});
                                }),
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),

                        /// Name Inputs
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: const BoxDecoration(
                              border: Border(
                                  right:
                                      BorderSide(color: Colors.blue, width: 3))),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                CustomTextField(
                                    label: "نام",
                                    controller: nameController,
                                    focus: firstNameFocus,
                                    validate: true),
                                const SizedBox(height: 15),
                                CustomTextField(
                                    label: "ایمیل", controller: emailController),
                                const SizedBox(height: 15),
                                CustomTextField(
                                  label: "شماره تلفن",
                                  validate: true,
                                  maxLength: 11,
                                  extraValidate: (val){
                                    String newVal = val!;
                                    if (val[0] == "0") {
                                      newVal = val.replaceFirst("0", "");
                                      phoneNumberController.text = newVal;
                                    }
                                    if (newVal.length != 10 || newVal[0] != "9") {
                                      return "شماره معتبر نیست";
                                    }
                                  },
                                  controller: phoneNumberController,
                                  textFormat: TextFormatter.number,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),

                        ///phones number part
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: const BoxDecoration(
                              border: Border(
                                  right:
                                      BorderSide(color: Colors.blue, width: 3))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CustomTextField(
                                controller: userNameController,
                              label: "نام کاربری",),
                              const Gap(10),
                              Row(
                                children: [
                                  CustomButton(
                                      text: "تغییر",
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                SetPasswordPanel(
                                                  oldPass:passwordController.text.isEmpty?null:
                                                      passwordController.text,
                                                )).then((value) {
                                          if (value != null) {
                                            passwordController.text = value;
                                            setState(() {});
                                          }
                                        });
                                      }),
                                  Expanded(
                                    child: PassTextField(
                                      enable: false,
                                      obscure:obscureOldPassword,
                                      label: "رمز",
                                      controller: passwordController,
                                      onChange: (val){
                                        obscureOldPassword=val;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              CustomTextField(
                                label: "توضیحات",
                                controller: descriptionController,
                                maxLength: 120,
                                maxLine: 4,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                  CustomButton(
                      width: 450,
                      text: widget.oldUser != null
                          ? "ذخیره تغییرات"
                          : "افزودن کاربر",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (widget.oldUser == null) {
                              saveUser();
                              showSnackBar(context, "کاربر جدید ایجاد شد!",
                                  type: SnackType.success);
                              Navigator.pop(context, false);

                          } else {
                            saveUser(id: widget.oldUser!.userId);
                            Navigator.pop(context, false);
                          }
                        }
                      }),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
