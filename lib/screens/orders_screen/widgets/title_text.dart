import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  const TitleText({super.key, required this.title, required this.value,this.color=Colors.black87});
  final String title;
  final String value;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(color: color,fontSize: 10),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(value, style: TextStyle(color: color,fontSize: 11)),
      ],
    );
  }
}