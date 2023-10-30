
import 'package:flutter/material.dart';

class SmallCardButton extends StatelessWidget {
  const SmallCardButton(
      {Key? key,
      required this.label,
      this.image,
        this.child,
      this.height = 100,
      this.width = 90,
        this.borderRadius=10,
      required this.onTap,
      this.direction = true})
      : super(key: key);
  final String label;
  final String? image;
  final Widget? child;
  final double width;
  final double height;
  final bool direction;
  final double borderRadius;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
        child: Column(
          children: [
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow:  [BoxShadow(spreadRadius: 1,blurRadius: 5,color: Colors.black.withOpacity(.3),offset: const Offset(2, 2))],
                color: Colors.white,
                image:image==null?null:DecorationImage(image: AssetImage("assets/icons/$image"),fit: BoxFit.cover) ,
              ),
              alignment: Alignment.bottomRight,
            ),
            SizedBox(child: Text(
              label,
              style:
              const TextStyle(color: Colors.black87, fontSize: 13),
            ),),
          ],
        ),
      ),
    );
  }
}
