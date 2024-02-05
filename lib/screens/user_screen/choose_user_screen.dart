import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/models/shop.dart';
import 'package:hitop_cafe/models/user.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/screens/home_screen/home_screen.dart';
import 'package:hitop_cafe/screens/user_screen/panels/set_password_panel.dart';
import 'package:hitop_cafe/screens/user_screen/widgets/user_tile.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class ChooseUserScreen extends StatefulWidget {
  static const String id = "/choose-user-screen";

  const ChooseUserScreen({super.key,this.onChange});
final Function(User? user)? onChange;
  @override
  State<ChooseUserScreen> createState() => _ChooseUserScreenState();
}

class _ChooseUserScreenState extends State<ChooseUserScreen> {
  final passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool passObscure = false;
  bool rememberUser = false;
  User? selectedUser;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(8).copyWith(top: 50),
        alignment: Alignment.center,
        decoration: const BoxDecoration(gradient: kMainGradiant),
        child: SizedBox(
          width: 450,
          child: ValueListenableBuilder(
              valueListenable: HiveBoxes.getUsers().listenable(),
              builder: (context, box, child) {
                List<User> userList = box.values.toList();
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ///title of the screen
                    const Text(
                      "انتخاب کاربر",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ///selected user name and password field
                    if (selectedUser != null)
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "کاربر: ${selectedUser?.name}",
                                style: const TextStyle(
                                    color: Colors.white60, fontSize: 18),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomButton(
                                    radius: 10,
                                    height: 45,
                                    color: kSecondaryColor,
                                    text: "ورود",
                                    icon: const Icon(Icons.login),
                                    onPressed: () {

                                      if (_formKey.currentState!.validate()) {
                                        Provider.of<UserProvider>(context,
                                                listen: false)
                                            .setUser(selectedUser);


                                        ///this condition is for when want to save user to do not enter password and choose user again
                                        if (rememberUser) {
                                          Shop shopInfo = HiveBoxes.getShopInfo()
                                              .values
                                              .single;
                                          shopInfo.activeUser = selectedUser;
                                          HiveBoxes.getShopInfo()
                                              .putAt(0, shopInfo);
                                        } else {
                                          Shop shopInfo = HiveBoxes.getShopInfo()
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
                                  const SizedBox(
                                    width: 5,
                                  ),

                                  ///password input part
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const CText("به یاد داشتن ورود",color: Colors.white60,),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Checkbox(
                                    activeColor: Colors.greenAccent,
                                    checkColor: Colors.teal,
                                      value: rememberUser,
                                      onChanged: (val) {
                                        rememberUser = !rememberUser;
                                        setState(() {});
                                      }),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    const Gap(20),
                    ///user list
                    Flexible(
                      child: Container(
                        height: 600,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white70),
                            borderRadius: BorderRadius.circular(20)),
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
    );
  }
}
