import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/constants.dart';
class DynamicButton extends StatefulWidget{
  const DynamicButton({
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
    this.labelStyle,
    this.iconSize,
  });

  final Widget? child;
  final Function? onPress;
  final VoidCallback? onLongPress;
  final IconData? icon;
  final String? label;
  final Color bgColor;
  final Color? iconColor;
  final double height;
  final double? width;
  final double? iconSize;
  final double borderRadius;
  final TextDirection direction;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final bool loading;
  final bool disable;
  final TextStyle? labelStyle;

  @override
  State<DynamicButton> createState() => _DynamicButtonState();
}
class _DynamicButtonState extends State<DynamicButton> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: Container(
            margin: widget.margin ?? const EdgeInsets.all(3),
            width: widget.width,
            height: widget.height,
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(widget.borderRadius))),
                  padding: MaterialStatePropertyAll(widget.padding ??
                      EdgeInsets.symmetric(
                          horizontal: widget.label == null ? 0 : 5,
                          vertical: 0)),
                  backgroundColor: MaterialStateProperty.all(widget.bgColor)),
              onPressed: widget.disable
                  ? () {}
                  : () async{
                loading=true;
                setState(() {});
                     await widget.onPress!();
                     loading=false;
                     setState(() {});
                    },
              onLongPress: widget.onLongPress,
              child: loading

                  ///show loading indicator
                  ? Container(
                      width: widget.height,
                      height: widget.height,
                      padding: const EdgeInsets.all(8.0),
                      child: const CircularProgressIndicator(
                        color: Colors.white70,
                        strokeWidth: 1.5,
                      ),
                    )
                  : widget.child != null
                      ? Directionality(
                          textDirection: TextDirection.ltr,
                          child: widget.child!)
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            constraint.maxWidth < 100
                                ? const SizedBox()
                                : Flexible(
                                    child: Text(
                                      widget.label ?? "",
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                      style: widget.labelStyle ??
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                            constraint.maxWidth < 100
                                ? const SizedBox()
                                : const SizedBox(
                                    width: 3,
                                  ),
                            if (widget.icon != null)
                              Icon(
                                widget.icon,
                                color: widget.iconColor ?? Colors.white,
                                size: widget.iconSize ?? 17,
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
