import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/error_handler.dart';
import 'package:hitop_cafe/constants/private.dart';
import 'package:hitop_cafe/models/shop.dart';
import 'package:hitop_cafe/models/user.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/screens/home_screen/home_screen.dart';
import 'package:hitop_cafe/screens/side_bar/purchase_app/services/payamito_api.dart';
import 'package:hitop_cafe/screens/user_screen/panels/set_password_panel.dart';
import 'package:hitop_cafe/screens/user_screen/widgets/user_tile.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class ChooseUserScreen extends StatefulWidget {
  static const String id = "/choose-user-screen";

  const ChooseUserScreen({super.key, this.onChange});
  final Function(User? user)? onChange;
  @override
  State<ChooseUserScreen> createState() => _ChooseUserScreenState();
}

class _ChooseUserScreenState extends State<ChooseUserScreen> {
  final phoneNumberController = TextEditingController();
  final authCodeController = TextEditingController();
  final passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool passObscure = false;
  bool rememberUser = false;
  User? selectedUser;

  final _codeFormKey = GlobalKey<FormState>();

  bool? isRightNumber;
  bool patient = false;

  bool msgLoading = false;
  bool authLoading = false;
  String? sendCode;

  ///send code button function
  Future<void> sendCodeFunction(context) async {
    isRightNumber=null;
    msgLoading = true;
    setState(() {});
    try {
      String phoneVal = selectedUser!.phone!;
      print(phoneVal);
      if (phoneVal.isNotEmpty && phoneVal[0] == "0") {
        phoneVal = phoneVal.replaceFirst("0", "");
        selectedUser!.phone = phoneVal;
      }
      print(phoneVal);
      if (phoneVal.isNotEmpty && phoneVal.length == 10 && phoneVal[0] == "9") {
        Map? phoneAuthData =
        await PayamitoApi.sentMessage(context, selectedUser!.phone!,bodyId:PrivateKeys.bodyIdEntry);

        if (phoneAuthData != null) {
          isRightNumber = phoneAuthData["isRight"];
          sendCode = phoneAuthData["authCode"];
          patient = true;
          setState(() {});
        }
      }else{
        isRightNumber=false;
      }

    } catch (error) {
      ErrorHandler.errorManger(context, error,
          title: "خطا در ارسال کد!",
          route: "AuthorityScreen sendCode button function error",
          showSnackbar: true);
      patient=false;
    }
    msgLoading = false;
    setState(() {});
  }

  ///button timer
  messageTimer(DateTime time) {
    return TimerCountdown(
      enableDescriptions: false,
      timeTextStyle: const TextStyle(color: Colors.white70),
      colonsTextStyle: const TextStyle(color: Colors.white70),
      spacerWidth: 0,
      format: CountDownTimerFormat.minutesSeconds,
      endTime: DateTime.now().add(
        const Duration(
          seconds: 60,
        ),
      ),
      onEnd: () {
        isRightNumber=null;
        patient = false;
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(8).copyWith(top: 50),
          decoration: const BoxDecoration(
              gradient: kMainGradiant,
          ),
          alignment: Alignment.center,
          child: Container(
            height: 800,
            width: 500,
            decoration: BoxDecoration(
                gradient: kBlackWhiteGradiant,
              borderRadius: BorderRadius.circular(20)
            ),
            child: ValueListenableBuilder(
                valueListenable: HiveBoxes.getUsers().listenable(),
                builder: (context, box, child) {
                  List<User> userList = box.values.toList();
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ///title of the screen
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.symmetric(vertical: 30),
                        decoration:
                             const BoxDecoration(gradient: kMainGradiant),
                        child: const Text(
                          "انتخاب کاربر و ورود",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              shadows: [kShadow]),
                        ),
                      ),
                      const Gap(20),
                      ///user name show  text
                      if (selectedUser != null)
                        Text(
                          "کاربر: ${selectedUser?.name}",
                          style:
                              const TextStyle(fontSize: 18, shadows: [kShadow]),
                        ),
                      const Gap(20),

                      ///tabs buttons
                      if (selectedUser != null)
                        const TabBar(tabs: [
                          Tab(
                            text: "ورود با پسوورد",
                          ),
                          Tab(
                            text: "ورود با کد یک بار مصرف",
                          ),
                        ]),

                      ///tab bar views
                      if (selectedUser != null)
                        Expanded(
                          child: TabBarView(children: [
                            ///selected user name and password field
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    ///password field and enter button
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ActionButton(
                                          borderRadius: 10,
                                          height: 45,
                                          width:
                                              selectedUser!.password.isNotEmpty
                                                  ? null
                                                  : 250,
                                          bgColor: kSecondaryColor,
                                          label: "ورود",
                                          icon: Icons.login,
                                          onPress: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              Provider.of<UserProvider>(context,
                                                      listen: false)
                                                  .setUser(selectedUser);

                                              ///this condition is for when want to save user to do not enter password and choose user again
                                              if (rememberUser) {
                                                Shop shopInfo =
                                                    HiveBoxes.getShopInfo()
                                                        .values
                                                        .single;
                                                shopInfo.activeUser =
                                                    selectedUser;
                                                HiveBoxes.getShopInfo()
                                                    .putAt(0, shopInfo);
                                              } else {
                                                Shop shopInfo =
                                                    HiveBoxes.getShopInfo()
                                                        .values
                                                        .single;
                                                shopInfo.activeUser = null;
                                                HiveBoxes.getShopInfo()
                                                    .putAt(0, shopInfo);
                                              }
                                              Navigator.pushReplacementNamed(
                                                  context, HomeScreen.id);
                                            }
                                          },
                                        ),
                                        const Gap(5),

                                        ///password input part
                                        if (selectedUser!.password.isNotEmpty)
                                          Expanded(
                                            child: PassTextField(
                                                label: "رمز ورود",
                                                obscure: passObscure,
                                                controller: passController,
                                                validate: (val) {
                                                  if (selectedUser!.password !=
                                                      passController.text) {
                                                    return "رمز اشتباه است";
                                                  }
                                                },
                                                onChange: (val) {
                                                  passObscure = val;
                                                  setState(() {});
                                                }),
                                          ),
                                      ],
                                    ),

                                    ///remember check box
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const CText(
                                          "به یاد داشتن ورود",
                                        ),
                                        Checkbox(
                                            activeColor: Colors.greenAccent,
                                            checkColor: Colors.teal,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            value: rememberUser,
                                            onChanged: (val) {
                                              rememberUser = !rememberUser;
                                              setState(() {});
                                            }),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ///phone number field and auth button
                                  Form(
                                    key: _codeFormKey,
                                    child: CustomTextField(
                                      label: "کد ارسال شده",
                                      controller: authCodeController,
                                      textFormat: TextFormatter.number,
                                      maxLength: 11,
                                      borderRadius: 50,
                                      validate: true,
                                      extraValidate: (val) {
                                        if (sendCode != val) {
                                          return "کد وارد شده معتبر نمی باشد!";
                                        }
                                      },
                                      suffixIcon: ActionButton(
                                          disable: patient,
                                          child: patient
                                              ? messageTimer(DateTime.now())
                                              : null,
                                          loading: msgLoading,
                                          label: "ارسال کد",
                                          icon: Icons.send,
                                          height: 40,
                                          bgColor: kSecondaryColor,
                                          onPress: () async {
                                              await sendCodeFunction(context);
                                          }),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 18,
                                  ),
                                  if (isRightNumber==true)
                                    CustomButton(
                                        loading: authLoading,
                                        text: "احراز و ورود",
                                        color: Colors.green,
                                        onPressed: () async {
                                          if (_codeFormKey.currentState!
                                              .validate()) {
                                            Provider.of<UserProvider>(context,
                                                    listen: false)
                                                .setUser(selectedUser);
                                              Shop shopInfo =
                                                  HiveBoxes.getShopInfo()
                                                      .values
                                                      .single;
                                              shopInfo.activeUser =
                                                  selectedUser;
                                              HiveBoxes.getShopInfo()
                                                  .putAt(0, shopInfo);

                                            Navigator.pushReplacementNamed(
                                                context, HomeScreen.id);
                                          }
                                        })
                                  else if(isRightNumber==false)
                                    const Center(child: Text("شماره تلفن کاربر صحیح نمی باشد",style: TextStyle(color: Colors.red),),)
                                ],
                              ),
                            ),
                          ]),
                        ),

                      const Gap(20),

                      ///user list
                      Flexible(
                        child: Container(
                          height: 600,
                          padding: const EdgeInsets.all(10),
                          child: ListView(
                              children: List.generate(
                            box.values.length,
                            (index) => UserTile(
                              selected: selectedUser == userList[index],
                              userDetail: userList[index],
                              onSee: () {
                                selectedUser = userList[index];
                                setState(() {});
                              },
                            ),
                          )),
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
