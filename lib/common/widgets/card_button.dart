
import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/constants.dart';

class CardButton extends StatelessWidget {
  const CardButton(
      {super.key,
      required this.label,
      this.image,
        this.child,
      this.height = 200,
      this.width = 150,
        this.borderRadius=2,
      required this.onTap,
      this.verticalDirection = true});
  final String label;
  final String? image;
  final Widget? child;
  final double width;
  final double height;
  final bool verticalDirection;
  final double borderRadius;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(5),
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(width: 0,color:kSecondaryColor),
          color: Colors.white,
          image:image==null?null:DecorationImage(image: AssetImage("assets/images/$image.jpg"),fit: BoxFit.cover) ,
            borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: const [
          BoxShadow(offset: Offset(2, 4),blurRadius: 5,color: Colors.black54),
        ]),
        alignment: Alignment.bottomRight,
        child:Stack(
          children: [
            SizedBox(child: child),
            Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.bottomRight,
            decoration: BoxDecoration(
                gradient: LinearGradient(
            begin:Alignment.bottomRight,
              end: !verticalDirection?Alignment.topLeft : Alignment.topRight,
              stops: const [.1,0.6],
              colors: const [kMainColor, Colors.transparent],
            ),
                borderRadius: BorderRadius.circular(borderRadius)),
            child: Text(
              label,
              style:
              const TextStyle(color: Colors.white, fontSize: 18),
            ),

          ),]
        ),
      ),
    );
  }
}


// direction
// ? Column(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// children: [
// icon,
// SizedBox(
// height: 10,
// ),
// Text(
// label,
// style:
// const TextStyle(color: kWhiteColor, fontSize: 25),
// ),
// ],
// )
// : Row(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// children: [
// icon,
// SizedBox(
// height: 10,
// ),
// ],
// ),
