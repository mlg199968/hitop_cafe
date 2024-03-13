import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/constants.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.onPress,
    this.icon,
    this.bgColor = kMainColor,
    this.label,
    this.height = 30,
    this.width,
    this.direction = TextDirection.rtl,
    this.onLongPress,
    this.iconColor,
    this.margin,
    this.padding,
    this.borderRadius = 20,
    this.loading = false,
    this.child,
    this.disable = false,
  });

  final Widget? child;
  final VoidCallback? onPress;
  final VoidCallback? onLongPress;
  final IconData? icon;
  final String? label;
  final Color bgColor;
  final Color? iconColor;
  final double height;
  final double? width;
  final double borderRadius;
  final TextDirection direction;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final bool loading;
  final bool disable;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: Container(
            margin: margin ?? const EdgeInsets.all(3),
            width: width,
            height: height,
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius))),
                  padding: MaterialStatePropertyAll(padding ??
                      EdgeInsets.symmetric(
                          horizontal: label == null ? 0 : 5, vertical: 0)),
                  backgroundColor: MaterialStateProperty.all(bgColor)),
              onPressed: disable ? () {} :onPress ,
              onLongPress: onLongPress,
              child: loading
                  ///show loading indicator
                  ? Container(
                      width: height,
                      height: height,
                      padding: const EdgeInsets.all(8.0),
                      child: const CircularProgressIndicator(
                        color: Colors.white70,
                        strokeWidth: 1.5,
                      ),
                    )
                  : child!=null?Directionality(textDirection: TextDirection.ltr, child: child!):
                      Row(
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
                                    style:
                                        const TextStyle(color: Colors.white),
                                  ),
                                ),
                          constraint.maxWidth < 100
                              ? const SizedBox()
                              : const SizedBox(
                                  width: 3,
                                ),
                          if (icon != null)
                            Icon(
                              icon,
                              color: iconColor ?? Colors.white,
                              size: 18,
                            ),
                        ],
                      ),
            ),
          ),
        ),
      );
    });
  }
}
