import 'package:flutter/material.dart';

class BillActionButton extends StatelessWidget {
  const BillActionButton(
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
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(bgColor)),
              onPressed: onPress,
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6,),
                  constraint.maxWidth<100?const SizedBox():Text(label ?? ""),
                ],
              ),
            ),
          );
        });
  }
}