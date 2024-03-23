import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/constants.dart';
class CounterTextfield extends StatelessWidget {
  const CounterTextfield({
    super.key,
    required this.controller,
    this.symbol,
    this.onChange,
    this.decimal = true,
    this.label,
    this.borderRadius = 20,
    this.step = 1,
    this.minNum = 0,
    this.maxNum = 1000000,
  });

  final TextEditingController controller;
  final bool decimal;
  final String? label;
  final String? symbol;
  final Function(String? val)? onChange;
  final double borderRadius;
  final double step;
  final double minNum;
  final double maxNum;

  @override
  Widget build(BuildContext context) {
    bool isPressed = false;
    return SizedBox(
      height: 40,
      width: 200,
      child: Row(
        children: [
          Flexible(
            child: TextFormField(

              controller: controller,
              keyboardType: TextInputType.numberWithOptions(decimal: decimal),
              onTapOutside: (val){
                num valNum=double.tryParse(controller.text )?? minNum;
                controller.text = decimal?valNum.toDouble().toString():valNum.toInt().toString();
                if (valNum < minNum) {
                  controller.text = minNum.toString();
                } else if (valNum > maxNum) {
                  controller.text = maxNum.toString();
                }
              },
              onChanged: (val) {
                // if (val != "" && val != "."  && val != "," &&
                //     val != "-" && stringToDouble(val) < 0) {
                //   controller.text = minNum.toString();
                // }
                if (onChange != null) {
                  onChange!(val);
                }
              },
              textAlign: TextAlign.center,
              onTap: () {
                if (!isPressed) {
                  //logic:when user tap on the textfield ,text get selected
                  controller.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: controller.value.text.length);
                }
                isPressed = true;
              },
              decoration: InputDecoration(
                ///counter buttons
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //add to value button
                    MiniButton(
                      icon: FontAwesomeIcons.angleUp,
                      onPress: () {
                        double num1 =
                            double.tryParse(controller.text) ?? minNum;
                        if (num1 < maxNum-step) {
                          num1 += step;
                          controller.text = decimal ? num1.toStringAsFixed(2) : num1.toInt().toString()
                              ;
                        } else {
                          controller.text = maxNum.toString();
                        }
                      },
                    ),
                    //subtract to value button
                    MiniButton(
                      icon: FontAwesomeIcons.angleDown,
                      onPress: () {
                        double num1 =
                            double.tryParse(controller.text) ?? minNum;
                        if (num1 > minNum+step) {
                          controller.text = decimal
                              ? (num1 - step).toStringAsFixed(2)
                              : (num1 - step).toInt().toString();
                        } else {
                          controller.text = minNum.toString();
                        }
                      },
                    ),
                  ],
                ),
                label: label == null
                    ? null
                    : Text(
                        label!,
                       style:const TextStyle( fontSize: 12),
                        maxLines: 2,
                      ),
                suffix: Text(symbol ?? ""),
                contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                counterText: "",
                filled: true,
                fillColor: Colors.white,
                hoverColor: Colors.white70,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: .5),
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: .5, color: kMainColor2),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius * .5),
                    borderSide:
                        const BorderSide(color: Colors.blueGrey, width: 1)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius * .8),
                    borderSide: const BorderSide(color: Colors.red)),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }
}

class MiniButton extends StatelessWidget {
  const MiniButton({
    super.key,
    required this.onPress,
    required this.icon,
  });

  final VoidCallback onPress;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 40,
      child: IconButton(
        onPressed: onPress,
        isSelected: false,
        color: kMainColor,
        style: ButtonStyle(
          padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
        ),
        icon: Icon(icon,size: 18,),
        enableFeedback: false,
      ),
    );
  }
}
