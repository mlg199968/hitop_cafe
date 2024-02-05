



import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/shape/shape1.dart';
import 'package:hitop_cafe/constants/constants.dart';


class BackgroundShape1 extends StatelessWidget {
  const BackgroundShape1({super.key,
    required this.child,
     this.color=kMainColor,
     this.height=80,this.width,
    this.borderRadius=10
  });
  final Widget child;
final Color color;
final double height;
final double? width;
final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
        ClipPath(
          clipper: Shape1(),
          child: Container(
            color: color.withOpacity(.8),
            width:width ?? MediaQuery.of(context).size.width*.7,
            height: height*.7,
          ),
        ),
        ClipPath(
          clipper: Shape1(),
          child: Container(
            color: color.withOpacity(.25),
            height: height,
            width: width,
          ),
        ),
        child
      ],),
    );
  }
}





