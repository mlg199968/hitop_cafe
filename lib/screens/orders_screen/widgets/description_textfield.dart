import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/screens/orders_screen/widgets/description_bar.dart';

///
class DescriptionField extends StatelessWidget {
  const DescriptionField(
      {super.key,
        required this.controller,
        required this.show,
        required this.onPress});
  final TextEditingController controller;
  final bool show;
  final VoidCallback onPress;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: TextButton.icon(
              onPressed: onPress,
              icon: Icon(
                show ? CupertinoIcons.minus_square : CupertinoIcons.plus_square,
                color: Colors.teal,
                size: 20,
              ),
              label: const CText(
                "توضیحات",
                color: Colors.teal,
              )),
        ),
        if (show)
          DescriptionBar(
              controller: controller,
              id: "order",
              onChange: (val) {
                controller.text = val ?? "";
              }),
        if (show)
          CustomTextField(
            controller: controller,
            label: "توضیحات سفارش",
            width: double.maxFinite,
            maxLine: 3,
            maxLength: 300,
          ),
      ],
    );
  }
}