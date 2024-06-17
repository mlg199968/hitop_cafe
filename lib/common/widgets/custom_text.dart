import 'package:flutter/material.dart';

class CText extends StatelessWidget {
  const CText(
    this.text, {
    super.key,
    this.fontSize = 12,
    this.color, this.maxLine, this.textDirection, this.shadow,
  });
  final String? text;
  final double fontSize;
  final int? maxLine;
  final Color? color;
  final TextDirection? textDirection;
  final BoxShadow? shadow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      style: TextStyle(
          fontSize: fontSize,
          color: color,
        shadows:shadow==null?null: [shadow!]
      ),
      overflow: TextOverflow.fade,
      maxLines:maxLine ,
      textDirection:textDirection,
    );
  }
}
