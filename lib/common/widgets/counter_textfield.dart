import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/utils.dart';

class CounterTextfield extends StatelessWidget {
  const CounterTextfield({
    super.key,
    required this.controller,
    this.symbol,
    this.onChange,
  });

  final TextEditingController controller;
  final String? symbol;
  final Function(String? val)? onChange;

  @override
  Widget build(BuildContext context) {
    bool isPressed = false;
    return SizedBox(
      height: 50,
      width: 200,
      child: Row(
        children: [
          Flexible(
            child: TextFormField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (val) {
                // if (val != "" && val != "."  && val != "," &&
                //     val != "-" && stringToDouble(val) < 0) {
                //   controller.text = 0.toString();
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
                suffix: Text(symbol ?? ""),
                contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                counterText: "",
                filled: true,
                fillColor: Colors.white,
                hoverColor: Colors.white70,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: .5),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: .5, color: kMainColor2),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        const BorderSide(color: Colors.blueGrey, width: 1)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.red)),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //add to value button
              MiniButton(
                icon: FontAwesomeIcons.angleUp,
                onPress: () {
                  double num1 = stringToDouble(
                      controller.text == "" ? "0" : controller.text);
                  controller.text = (num1 + 1).toString();
                },
              ),
              //subtract to value button
              MiniButton(
                icon: FontAwesomeIcons.angleDown,
                onPress: () {
                  if(stringToDouble(controller.text)>0) {
                    controller.text =
                      (stringToDouble(controller.text) - 1).toString();
                  }
                },
              ),
            ],
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
      child: ElevatedButton(
        onPressed: onPress,
        style: ButtonStyle(
          padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
        ),
        child: Icon(icon),
      ),
    );
  }
}
