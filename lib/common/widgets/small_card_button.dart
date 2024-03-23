
import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/constants.dart';

class SmallCardButton extends StatelessWidget {
  const SmallCardButton(
      {super.key,
      required this.label,
      this.image,
        this.child,
      this.height = 100,
      this.width = 100,
        this.borderRadius=40,
      required this.onTap,
      this.direction = true});
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
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
        child: Column(
          children: [
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                //shape: BoxShape.circle,
                color: Colors.white,
                gradient: kBlackWhiteGradiant.scale(.9),
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow:  [BoxShadow(spreadRadius: 1,blurRadius: 5,color: Colors.black.withOpacity(.3),offset: const Offset(2, 2))],

                image:image==null?null:DecorationImage(image: AssetImage("assets/icons/$image"),fit: BoxFit.cover) ,
              ),
              alignment: Alignment.bottomRight,
            ),
            const SizedBox(height: 5,),
            SizedBox(child: Text(
              label,
              style:
              const TextStyle(color: Colors.black54, fontSize: 13),
            ),),
          ],
        ),
      ),
    );
  }
}
