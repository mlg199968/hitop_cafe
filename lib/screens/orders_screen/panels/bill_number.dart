import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/constants/utils.dart';

class BillNumber extends StatefulWidget {
  const BillNumber({Key? key}) : super(key: key);

  @override
  State<BillNumber> createState() => _WareToBillPanelState();
}

class _WareToBillPanelState extends State<BillNumber> {
  final _formKey=GlobalKey<FormState>();
  TextEditingController tableNumberController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Center(child: Text("شماره فاکتور")),
        elevation: 50,
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.blue.shade300.withOpacity(.2),
        content: ClipRect(
          child: BackdropFilter(
            filter:ImageFilter.blur(sigmaX: 3,sigmaY: 3),
            child: Container(
              height: MediaQuery.of(context).size.height * .3,
              width: double.maxFinite,
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    CustomTextField(
                      label: "شماره میز",
                      controller:tableNumberController,
                      width: MediaQuery.of(context).size.width,
                      textFormat: TextFormatter.number,
                      maxLength: 15,
                      validate: true,
                    ),
                    const SizedBox(height: 20,),

                    CustomButton(
                        width: MediaQuery.of(context).size.width,
                        text: "Add to Bill",
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pop(context,stringToDouble(tableNumberController.text));
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
