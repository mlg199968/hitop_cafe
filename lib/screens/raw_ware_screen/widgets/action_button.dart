import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton(
      {super.key,
      required this.onPress,
      required this.icon,
      this.bgColor = Colors.blue,
      this.label,
      this.height = 35,
      this.direction = TextDirection.rtl});

  final VoidCallback onPress;
  final IconData icon;
  final String? label;
  final Color bgColor;
  final double height;
  final TextDirection direction;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          height: height,
          child: ElevatedButton(
            style: ButtonStyle(
                padding: const MaterialStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 5, vertical: 0)),
                backgroundColor: MaterialStateProperty.all(bgColor)),
            onPressed: onPress,
            child: Row(
              children: [
                constraint.maxWidth < 100
                    ? const SizedBox()
                    : Text(
                        label ?? "",
                        style: const TextStyle(color: Colors.white),
                      ),
                constraint.maxWidth < 100
                    ? const SizedBox()
                    : const SizedBox(width: 3,),
                Icon(
                  icon,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
