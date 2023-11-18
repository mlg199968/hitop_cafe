import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_alert_dialog.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/raw_ware.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';

class SelectedWareActionPanel extends StatefulWidget {
  const SelectedWareActionPanel(
      {Key? key, required this.wares})
      : super(key: key);
  final List<RawWare> wares;


  @override
  State<SelectedWareActionPanel> createState() => _SelectedWareActionPanelState();
}

class _SelectedWareActionPanelState extends State<SelectedWareActionPanel> {
  final TextEditingController percentController = TextEditingController();
  final TextEditingController fixAmountController = TextEditingController();

  @override
  void initState() {

    percentController.text = "0";
    fixAmountController.text = "0";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Text("افزایش یا کاهش قیمت موارد انتخاب شده "),
            ),

            ///price text fields
            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: CustomTextField(
                      label: "مبلغ ثابت",
                      controller: fixAmountController,
                      textFormat: TextFormatter.price,
                    )),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: CustomTextField(
                  label: "درصد",
                  controller: percentController,
                  textFormat: TextFormatter.number,
                  onChange: (val) {
                    if (val != "" &&
                        val != "-" &&
                        val != "." &&
                        val != "-." &&
                        stringToDouble(val) > 1000) {
                      percentController.text = 1000.toString();
                      setState(() {});
                    }
                  },
                )),
              ],
            ),
            const SizedBox(
              height: 15,
            ),

            ///buttons
            CustomButton(
                text: "ثبت",
                onPressed: () {
                  for (RawWare ware in widget.wares) {
                    double fixPrice = fixAmountController.text == ""
                        ? 0
                        : stringToDouble(fixAmountController.text);
                    double percent = percentController.text == ""
                        ? 0
                        : stringToDouble(percentController.text);
                      ware.cost = ware.cost +
                          fixPrice +
                          (ware.cost * percent / 100);
                      ware.cost = ware.cost +
                          fixPrice +
                          (ware.cost * percent / 100);
                      HiveBoxes.getRawWare().put(ware.wareId, ware);

                  }
                  Navigator.pop(context, false);
                }),
            const SizedBox(
              width: 5,
            ),
          ],
        ));
  }
}
