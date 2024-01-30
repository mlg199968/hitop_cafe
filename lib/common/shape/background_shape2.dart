



import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/shape/shape2.dart';


class BackgroundShape2 extends StatelessWidget {
  const BackgroundShape2({super.key,
    required this.child,
     this.color=Colors.blue,
     this.height=60, this.width=200,
  });
  final Widget child;
final Color color;
final double height;
final double width;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
      ClipPath(
        clipper: Shape2(),
        child: Container(
          color: color.withOpacity(.5),
          width:MediaQuery.of(context).size.width,
          height: height,
        ),
      ),
      ClipPath(
        clipper: Shape2(),
        child: Container(
          color: color.withOpacity(.7),
          width: MediaQuery.of(context).size.width*.5,
          height: height,
        ),
      ),
      child
    ],);
  }


}
