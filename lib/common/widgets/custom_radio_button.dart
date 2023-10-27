import 'package:flutter/material.dart';

class CustomRadioButton extends StatelessWidget {
  const CustomRadioButton(
      {super.key,
      required this.onChange(ButtonLogic butt),
      required this.setVal});
  final Function onChange;
  final ButtonLogic setVal;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Opacity(
              opacity: setVal.notSettle ? 1 : .6,
              child: InkWell(
                  onTap: () {
                    ButtonLogic butt =
                        ButtonLogic.setVal(false, true, false, false);
                    //condition for active or deActive the button
                    if (setVal.all) {
                      butt = ButtonLogic.setVal(false, true, false, false);
                    } else if (!setVal.all && setVal.notSettle) {
                      butt = ButtonLogic.setVal(false, false, false, true);
                    }
                    onChange(butt);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    height: 40,
                    decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius:
                            BorderRadius.horizontal(left: Radius.circular(10))),
                    child: const Text(
                      "تسویه نشده",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  )),
            ),
          ),
          const SizedBox(
            width: 1,
          ),
          Expanded(
            flex: 1,
            child: Opacity(
              opacity: setVal.settle ? 1 : .6,
              child: InkWell(
                  onTap: () {
                    ButtonLogic butt =
                        ButtonLogic.setVal(true, false, false, false);
                    //condition for active or deActive the button
                    if (setVal.all) {
                      butt = ButtonLogic.setVal(true, false, false, false);
                    } else if (!setVal.all && setVal.settle) {
                      butt = ButtonLogic.setVal(false, false, false, true);
                    }
                    onChange(butt);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: const Text(
                      "تسویه شده",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  )),
            ),
          ),
          const SizedBox(
            width: 1,
          ),
          Expanded(
            flex: 1,
            child: Opacity(
              opacity: setVal.creditor ? 1 : .6,
              child: InkWell(
                onTap: () {
                  ButtonLogic butt =
                      ButtonLogic.setVal(false, false, true, false);
                  //condition for active or deActive the button
                  if (setVal.all) {
                    butt = ButtonLogic.setVal(false, false, true, false);
                  } else if (!setVal.all && setVal.creditor) {
                    butt = ButtonLogic.setVal(false, false, false, true);
                  }
                  onChange(butt);
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(5),
                  height: 40,
                  decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius:
                          BorderRadius.horizontal(right: Radius.circular(10))),
                  child: const Text(
                    "بستانکار",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonLogic {
  bool settle = false;
  bool notSettle = false;
  bool all = true;
  bool creditor = false;
  ButtonLogic(
      {required this.settle,
      required this.notSettle,
      required this.creditor,
      required this.all});
  factory ButtonLogic.setVal(
          bool settle1, bool notSettle1, bool creditor1, bool all1) =>
      ButtonLogic(
        settle: settle1,
        notSettle: notSettle1,
        creditor: creditor1,
        all: all1,
      );
}
