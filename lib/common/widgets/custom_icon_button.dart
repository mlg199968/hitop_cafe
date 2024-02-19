import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/constants.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {super.key,
      this.onPress,
      required this.icon,
      this.bgColor,
      this.label,
      this.height = 30,
      this.width,
      this.direction = TextDirection.rtl,
      this.onLongPress,
      this.iconColor,
      this.margin,
      this.padding,
      this.borderRadius = 20, this.iconSize});

  final VoidCallback? onPress;
  final VoidCallback? onLongPress;
  final IconData icon;
  final String? label;
  final Color? bgColor;
  final Color? iconColor;
  final double? iconSize;
  final double height;
  final double? width;
  final double borderRadius;
  final TextDirection direction;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          margin: margin ?? const EdgeInsets.all(0),
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: onPress,
            child: Container(
              padding:padding ??
                  const EdgeInsets.all(5),
              decoration:  BoxDecoration(
                color:bgColor,
                borderRadius: BorderRadius.circular(borderRadius),

              ),
              child: Icon(
                icon,
                semanticLabel: label,
                color: iconColor ?? kSecondaryColor,
                size: iconSize,
              ),
            ),
          ),
        ),
      );
    });
  }
}
