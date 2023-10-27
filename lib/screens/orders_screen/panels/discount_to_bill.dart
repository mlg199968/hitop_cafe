import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_alert_dialog.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
class DiscountToBill extends StatefulWidget {
  const DiscountToBill({Key? key}) : super(key: key);

  @override
  State<DiscountToBill> createState() => _WareToBillPanelState();
}

class _WareToBillPanelState extends State<DiscountToBill> {
  String date = Jalali.now().formatCompactDate();
  DateTime originDate=DateTime.now();
  TextEditingController cashController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      context: context,
        title: "تعیین تخفیف",
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            CustomTextField(
              label: "مقدار تخفیف",
              controller: cashController,
              width: MediaQuery.of(context).size.width,
              textFormat: TextFormatter.price,
              maxLength: 15,
            ),
            const SizedBox(height: 20,),

            CustomButton(
                width: MediaQuery.of(context).size.width,
                text: "افزودن به فاکتور",
                onPressed: () {
                  if (cashController.text.isNotEmpty) {
                    Navigator.pop(context,stringToDouble(cashController.text));
                  }
                }),
          ],
        ));
  }
}
