import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';

class EmptyHolder extends StatelessWidget {
  const EmptyHolder({
    super.key, required this.text, required this.icon, this.color,
  });
  final String text;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 300,
      child: Center(
          child: Column(
            mainAxisAlignment:MainAxisAlignment.center ,
            children: [
              Icon(icon,size: 30,color: color ?? Colors.black38,),
              const SizedBox(height: 5,),
              CText(
                text,
                fontSize: 10,
                color:color ?? Colors.black38,
              ),
            ],
          )),
    );
  }
}