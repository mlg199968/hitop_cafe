import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/constants.dart';

class CustomFloatActionButton extends StatelessWidget {
  const CustomFloatActionButton(
      {Key? key,
      required this.onPressed,
      this.icon,
      this.bgColor=kMainColor,
      this.fgColor=Colors.white,
      this.label})
      : super(key: key);

  final IconData? icon;
  final String? label;
  final Color? bgColor;
  final Color? fgColor;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: label==null?null:50,
      width: label==null?60:null,
      child: FloatingActionButton.extended(
        label:Text(label ?? "",style: const TextStyle(fontSize: 20),),
        icon:  Icon(
          icon ?? Icons.add_rounded,
          size: 45,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        isExtended: label==null?false:true,
        elevation: 4,
        onPressed: onPressed,
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

class CustomFabLoc extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    return Offset(
      scaffoldGeometry.scaffoldSize.width * .8,

      ///customize here
      scaffoldGeometry.scaffoldSize.height * .83,
    );
  }
}
