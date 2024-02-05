import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class TitleButton extends StatelessWidget {
  const TitleButton({super.key, required this.title, required this.value, required this.onPress,this.color=Colors.black54});
  final String title;
  final String value;
  final VoidCallback onPress;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(color: color,fontSize: 11),
        ),
        const SizedBox(
          width: 5,
        ),
        InkWell(

            onTap: onPress,
            child: Text(value.toPersianDigit(), style: const TextStyle(fontSize: 12,color: Colors.blue))),
      ],
    );
  }
}