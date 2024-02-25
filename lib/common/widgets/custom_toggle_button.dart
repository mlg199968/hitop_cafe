

import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/constants/constants.dart';

class CustomToggleButton extends StatelessWidget {
  const CustomToggleButton({super.key, required this.labelList, this.widgetList, required this.selected, required this.onPress});
final List<String> labelList;
final List<Widget>? widgetList;
final String selected;
final Function(int index) onPress;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: ToggleButtons(
        borderRadius: BorderRadius.circular(20),
        fillColor:kMainColor ,
        selectedColor: Colors.white,
        isSelected: labelList.map((e) {
          if(selected==e) {
              return true;
            }
          else{
            return false;
          }
          }).toList(),
        onPressed:onPress,
        children:widgetList!=null
            ? widgetList!
            : labelList.map((e) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CText(e,fontSize: 12,),
            ),).toList(),
      ),
    );
  }
}
