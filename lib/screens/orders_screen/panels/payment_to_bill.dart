import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_alert_dialog.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/common/widgets/drop_list_model.dart';
import 'package:hitop_cafe/constants/consts_class.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/payment.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:uuid/uuid.dart';

class PaymentToBill extends StatefulWidget {
  const PaymentToBill(this.payable,{super.key});
  final num payable;

  @override
  State<PaymentToBill> createState() => _CashToBillState();
}

class _CashToBillState extends State<PaymentToBill> {
  final _formKey = GlobalKey<FormState>();

  final String date = Jalali.now().formatCompactDate();

  final DateTime originDate = DateTime.now();

  final TextEditingController amountController = TextEditingController();

  final List<String> payMethods = [
    PayMethod.atmPersian,
    PayMethod.cashPersian,
    PayMethod.discountPersian,
  ];

  String pMethod =PayMethod.atmPersian ;

  @override
  void initState() {
    amountController.text=addSeparator(widget.payable);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
        title: "پرداخت جدید",
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("روش پرداخت"),
                  DropListModel(
                      listItem: payMethods,
                      selectedValue: pMethod,
                      onChanged: (val) {
                        pMethod=val;
                        setState(() {});
                      }),
                ],
              ),
              const SizedBox(height: 20,),
              CustomTextField(
                label: "میزان پرداخت",
                controller: amountController,
                width: MediaQuery.of(context).size.width,
                textFormat: TextFormatter.price,
                maxLength: 15,
                validate: true,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                  width: MediaQuery.of(context).size.width,
                  text: "افزودن به فاکتور",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Payment payment = Payment()
                      ..   method= PayMethod().persianToEnglish(pMethod)
                      ..   amount= stringToDouble(amountController.text)
                      ..   deliveryDate= DateTime.now()
                      .. paymentId= const Uuid().v1()
                      ;
                      Navigator.pop(context, payment);
                    }
                  }),
            ],
          ),
        ));
  }
}
