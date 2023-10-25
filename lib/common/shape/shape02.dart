



import 'package:flutter/material.dart';


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
        clipper: CustomShape(),
        child: Container(
          color: color.withOpacity(.5),
          width:MediaQuery.of(context).size.width,
          height: height,
        ),
      ),
      ClipPath(
        clipper: CustomShape(),
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





class CustomShape extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    double w=size.width;
    double h=size.height;
    const double radius=20;
    var point1Start=Offset(w*.4, h*.3);
    var point1End=Offset(w*.1, h*.5);
    var point2Start=Offset(w*.25, h*.8);
    var point2End=Offset(radius+20, h*1);
    Path path =Path();
    path.moveTo(w*0, h+radius);
    path.lineTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    path.lineTo(w*.5, 0);
    path.quadraticBezierTo(point1Start.dx, point1Start.dy, point1End.dx, point1End.dy);
    path.quadraticBezierTo(point1Start.dx*.8, point1Start.dy*1.3, point1End.dx, point1End.dy*1.5);
    path.quadraticBezierTo(point2Start.dx, point2Start.dy, point2End.dx, point2End.dy);
    path.lineTo(radius, h);
    path.quadraticBezierTo(0, h, 0,h-radius);
     path.lineTo(0, radius);


    path.close();

    // var point2Start=Offset(size.width*0, size.height*.7);
    // var point2End=Offset(size.width, 0);


    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
    //UnimplementedError();
  }




}