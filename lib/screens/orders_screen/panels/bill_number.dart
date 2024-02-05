import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_alert_dialog.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/constants/utils.dart';

class BillNumber extends StatefulWidget {
  const BillNumber({super.key});

  @override
  State<BillNumber> createState() => _WareToBillPanelState();
}

class _WareToBillPanelState extends State<BillNumber> {
  final _formKey=GlobalKey<FormState>();
  TextEditingController tableNumberController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      opacity: .3,
        title: "شماره فاکتور",
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                CustomTextField(
                  label: "شماره فاکتور",
                  controller:tableNumberController,
                  width: MediaQuery.of(context).size.width,
                  textFormat: TextFormatter.number,
                  maxLength: 15,
                  validate: true,
                ),
                const SizedBox(height: 20,),

                CustomButton(
                    width: MediaQuery.of(context).size.width,
                    text: "ذخیره شماره",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pop(context,stringToDouble(tableNumberController.text));
                      }
                    }),
              ],
            ),
          ),
        ));
  }
}
