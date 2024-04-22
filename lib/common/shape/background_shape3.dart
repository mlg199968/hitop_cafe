



import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/shape/shape1.dart';


class BackgroundShape3 extends StatelessWidget {
  const BackgroundShape3({super.key,
    required this.child,
     this.color=Colors.blue,
     this.height=60, this.width=200,this.borderRadius=10,
  });
  final Widget child;
final Color color;
final double height;
final double width;
final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraint) {
        double maxWidth=constraint.maxWidth;
        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
            ClipPath(
              clipper: Shape1(),
              child: Container(
                decoration:  BoxDecoration(gradient: LinearGradient(colors: [color.withOpacity(.1),color.withOpacity(.5)])),
                // color: color.withOpacity(.5),
                width:maxWidth*.8,
                height: height,
              ),
            ),
            ClipPath(
              clipper: Shape1(),
              child: Container(
                decoration:  BoxDecoration(gradient: LinearGradient(colors: [color.withOpacity(.8),color.withBlue(150).withOpacity(.3)])),
                // color: color.withOpacity(.7),
                width: maxWidth*.6,
                height: height*.35,
              ),
            ),
            child
          ],),
        );
      }
    );
  }


}
