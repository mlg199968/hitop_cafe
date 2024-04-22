import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/counter_textfield.dart';
import 'package:hitop_cafe/common/widgets/custom_dialog.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/constants/utils.dart';

class DialogTextField extends StatefulWidget {
  const DialogTextField({super.key, this.oldValue, this.isCounter=true, this.label});
  final String? label;
final String? oldValue;
final bool isCounter;
  @override
  State<DialogTextField> createState() => _DialogTextFieldState();
}

class _DialogTextFieldState extends State<DialogTextField> {
  final _formKey=GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    controller.text=widget.oldValue ?? "1";
    super.initState();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      opacity: .7,
        title: "شماره فاکتور",
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(widget.isCounter)
                CounterTextfield(
                  label: widget.label ?? "",
                  controller:controller,
                  decimal: false,
                  maxNum: 999999999999,
                )
                else
                CustomTextField(
                  label: widget.label ?? "",
                  controller:controller,
                  textFormat: TextFormatter.number,
                  maxLength: 15,
                  validate: true,
                ),
                const SizedBox(height: 20,),

                CustomButton(
                    text: "ذخیره",
                    radius: 25,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pop(context,stringToDouble(controller.text));
                      }
                    }),
              ],
            ),
          ),
        ));
  }
}
