import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/utils.dart';


class TextDataField extends StatelessWidget {
  const TextDataField({Key? key, required this.title, required this.value,this.color=Colors.black87}) : super(key: key);
  final String title;
  final num value;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(color: color,fontSize: 13),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(addSeparator(value),textDirection: TextDirection.ltr, style: TextStyle(color: color,fontSize: 13)),
      ],
    );
  }
}