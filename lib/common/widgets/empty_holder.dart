import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';

class EmptyHolder extends StatelessWidget {
  const EmptyHolder({
    super.key, required this.text, required this.icon, this.color,this.iconSize=30,this.fontSize=10, this.height,
  });
  final String text;
  final IconData icon;
  final Color? color;
  final double iconSize;
  final double fontSize;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height:height ?? 300,
      child: Center(
          child: Column(
            mainAxisAlignment:MainAxisAlignment.center ,
            children: [
              Icon(icon,size: iconSize,color: color ?? Colors.black38,),
              const SizedBox(height: 5,),
              CText(
                text,
                fontSize: fontSize,
                color:color ?? Colors.black38,
                textDirection: TextDirection.rtl,
              ),
            ],
          )),
    );
  }
}