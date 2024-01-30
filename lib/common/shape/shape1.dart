import 'package:flutter/material.dart';

class Shape1 extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    var point1Start=Offset(size.width*.6, size.height*.6);
    var point1End=Offset(size.width*.3, size.height);
    Path path =Path();
    path.moveTo(size.width, size.height);
    path.lineTo(size.width, size.height*.8);

    path.quadraticBezierTo(point1Start.dx, point1Start.dy, point1End.dx, point1End.dy);
    path.close();

    // var point2Start=Offset(size.width*0, size.height*.7);
    // var point2End=Offset(size.width, 0);
    // path.quadraticBezierTo(point2Start.dx, point2Start.dy, point2End.dx, point2End.dy);
    // path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
    //UnimplementedError();
  }
}