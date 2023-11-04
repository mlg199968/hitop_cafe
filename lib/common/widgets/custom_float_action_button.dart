import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomFloatActionButton extends StatelessWidget {
  const CustomFloatActionButton(
      {Key? key,
      required this.onPressed,
      this.icon,
      this.bgColor,
      this.fgColor,
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
      child: FloatingActionButton.extended(
        label:Text(label ?? "",style: const TextStyle(fontSize: 20),),
        icon:  Icon(
          icon ?? FontAwesomeIcons.plus,
          size: 30,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        isExtended: label==null?false:true,
        elevation: 4,
        onPressed: onPressed,
        backgroundColor: bgColor ?? Colors.brown,
        foregroundColor: fgColor ?? Colors.white,
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
