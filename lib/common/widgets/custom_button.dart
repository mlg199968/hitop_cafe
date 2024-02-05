import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/constants.dart';
class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.text,
      required this.onPressed,
        this.color,
      this.width,
      this.height = 40,
        this.fontSize=15,
        this.radius=5, this.icon, this.replacementIcon, this.margin,
      });
  final String text;
  // ignore: prefer_typing_uninitialized_variables
  final  onPressed;
  final double? width;
  final double? height;
  final Color? color;
  final double fontSize;
  final double radius;
  final Icon? icon;
  final IconData? replacementIcon;
  final EdgeInsets? margin;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: const ButtonStyle(
        elevation: MaterialStatePropertyAll(5),
          padding: MaterialStatePropertyAll(EdgeInsets.all(0))),
      onPressed: onPressed,
      child: Container(
        margin: margin,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: color,
              gradient:color==null?kMainGradiant:LinearGradient(
                colors: [color!, color!.withAlpha(150)],
              ),
              borderRadius: BorderRadius.circular(radius),
            boxShadow: const [
              BoxShadow(blurRadius: 2,offset: Offset(1, 3),color: Colors.black26)
            ],),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: AutoSizeText(
                  text,
                  maxFontSize: fontSize,
                  minFontSize: 10,
                  maxLines: 1,
                  overflow:TextOverflow.fade ,
                  overflowReplacement:replacementIcon==null?null:Icon(replacementIcon),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              icon!=null?Padding(
                padding: const EdgeInsets.only(left: 5),
                child: icon!,
              ):const SizedBox()
            ],
          )),
    );
  }
}
