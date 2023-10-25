import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton(
      {super.key,
        required this.onPress,
        required this.icon,
        this.bgColor = Colors.blue, this.label});

  final VoidCallback onPress;
  final IconData icon;
  final String? label;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context,constraint){
          return ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(bgColor)),
            onPressed: onPress,
            child: Row(
              children: [
                constraint.maxWidth<100?const SizedBox():Text(label ?? "",style: const TextStyle(color: Colors.white),),
                Icon(
                  icon,
                  color: Colors.white,
                ),
              ],
            ),
          );
        });
  }
}