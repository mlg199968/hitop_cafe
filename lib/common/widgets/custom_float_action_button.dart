

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';




class CustomFloatActionButton extends StatelessWidget {
  const CustomFloatActionButton({Key? key,required this.onPressed}) : super(key: key);
final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return  FloatingActionButton(

      elevation: 4,
      onPressed:onPressed,
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: const Icon(FontAwesomeIcons.plus,size: 30,),
    );
  }
}



class CustomFabLoc extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    return Offset(
      scaffoldGeometry.scaffoldSize.width * .8, ///customize here
      scaffoldGeometry.scaffoldSize.height * .83,
    );
  }
}
