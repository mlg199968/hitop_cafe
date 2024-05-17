import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/screens/orders_screen/widgets/description_bar.dart';

///
class DescriptionField extends StatelessWidget {
  const DescriptionField({
    super.key,
    required this.controller,
    required this.show,
    required this.onPress, this.label, this.id,
    this.soloDes=false,
  });
  final TextEditingController controller;
  final String? label;
  final String? id;
  final bool show;
  final bool soloDes;
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
              soloDes: soloDes,
              id: id ?? "public",
              onChange: (val) {
                controller.text = val ?? "";
              }),
        if (show)
          CustomTextField(
            controller: controller,
            label: label ?? "توضیحات",
            width: double.maxFinite,
            maxLine: 3,
            maxLength: 300,
          ),
      ],
    );
  }
}
