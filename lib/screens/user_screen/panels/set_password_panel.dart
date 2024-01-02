import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_alert_dialog.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';

class SetPasswordPanel extends StatefulWidget {
  const SetPasswordPanel({super.key, this.oldPass});

  final String? oldPass;

  @override
  State<SetPasswordPanel> createState() => _SetPasswordPanelState();
}

class _SetPasswordPanelState extends State<SetPasswordPanel> {
  final _formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();

  final newPasswordController = TextEditingController();

  final newPasswordReapedController = TextEditingController();

  bool obscureOldPassword = true;

  bool obscureNewPassword = true;

  bool obscureNewPasswordReaped = true;

  @override
  void initState() {
    oldPasswordController.text = widget.oldPass ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.oldPass);
    return CustomDialog(
      opacity: .8,
      title: "تنظیم رمزعبور",
      child: Container(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.oldPass != null ||
                  widget.oldPass !=
                      ""
                          "")
                PassTextField(
                  label: "رمز حاضر",
                  controller: oldPasswordController,
                  obscure: obscureOldPassword,
                  onChange: (val) {
                    obscureOldPassword = val;
                    setState(() {});
                  },
                  // validate: (val){
                  //   // if(widget.oldPass!=null && widget.oldPass! !=val){
                  //   //   return "رمز اشتباه است";
                  //   // }
                  // },
                ),
              const SizedBox(
                height: 30,
              ),
              PassTextField(
                obscure: obscureNewPassword,
                label: "رمز جدید",
                controller: newPasswordController,
                onChange: (val) {
                  obscureNewPassword = val;
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 10,
              ),
              PassTextField(
                obscure: obscureNewPasswordReaped,
                label: "تکرار رمز جدید",
                controller: newPasswordReapedController,
                onChange: (val) {
                  obscureNewPasswordReaped = val;
                  setState(() {});
                },
                validate: (val) {
                  if (newPasswordController.text !=
                      newPasswordReapedController.text) {
                    return "تکرار رمز اشتباه است";
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                text: "تغییر",
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context, newPasswordReapedController.text);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PassTextField extends StatelessWidget {
  const PassTextField(
      {super.key,
      required this.controller,
      this.label,
      this.obscure = false,
      this.enable = true,
      required this.onChange,
      this.validate});

  final TextEditingController controller;
  final String? label;
  final bool obscure;
  final bool enable;
  final Function(bool obscure) onChange;
  final Function(String? obscure)? validate;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: label,
      enable: enable,
      validate: validate==null?false: true,
      extraValidate: validate,
      controller: controller,
      obscure: obscure,
      suffixIcon: IconButton(
        icon: const Icon(Icons.remove_red_eye),
        onPressed: () {
          onChange(!obscure);
        },
      ),
    );
  }
}
