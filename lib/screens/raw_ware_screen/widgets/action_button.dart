import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/constants.dart';

class ActionButton extends StatelessWidget {
  const ActionButton(
      {super.key,
      this.onPress,
      required this.icon,
      this.bgColor = kMainColor,
      this.label,
      this.height = 35,
      this.width,
      this.direction = TextDirection.rtl, this.onLongPress});

  final VoidCallback? onPress;
  final VoidCallback? onLongPress;
  final IconData icon;
  final String? label;
  final Color bgColor;
  final double height;
  final double? width;
  final TextDirection direction;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          width: width,
          height: height,
          child: ElevatedButton(
            style: ButtonStyle(
                padding: const MaterialStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 5, vertical: 0)),
                backgroundColor: MaterialStateProperty.all(bgColor)),
            onPressed: onPress,
            onLongPress: onLongPress,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                constraint.maxWidth < 100
                    ? const SizedBox()
                    : Flexible(
                      child: Text(
                          label ?? "",
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          style: const TextStyle(color: Colors.white),
                        ),
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
