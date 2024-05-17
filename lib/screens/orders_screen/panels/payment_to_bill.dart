import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/custom_dialog.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/common/widgets/custom_toggle_button.dart';
import 'package:hitop_cafe/constants/consts_class.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/payment.dart';
import 'package:hitop_cafe/screens/orders_screen/widgets/description_textfield.dart';
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
bool showDes=false;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final List<String> payMethods = [
    PayMethod.atmPersian,
    PayMethod.cashPersian,
    PayMethod.cardPersian,
    PayMethod.discountPersian,
  ];
   List<bool> payBool = [
    true,
    false,
    false,
    false,
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
      actions: [
        Flexible(
          child: CustomButton(
              width: 500,
              text: "افزودن به فاکتور",
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Payment payment = Payment()
                    ..   method= PayMethod().persianToEnglish(pMethod)
                    ..   amount= stringToDouble(amountController.text)
                    ..description=descriptionController.text
                    ..   deliveryDate= DateTime.now()
                    .. paymentId= const Uuid().v1()
                  ;
                  Navigator.pop(context, payment);
                }
              }),
        ),
      ],
        title: "پرداخت جدید",
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: CustomToggleButton(labelList: payMethods,
                  selected: pMethod,
                  onPress: (index){
                    setState(() {
                      pMethod=payMethods[index];
                    });
                  },
                ),
              ),
              const Gap(20),
              ///pay amount textfield
              CustomTextField(
                label: "میزان پرداخت",
                controller: amountController,
                width: MediaQuery.of(context).size.width,
                textFormat: TextFormatter.price,
                maxLength: 15,
                validate: true,
              ),
              const Gap(20),
              ///pay amount textfield
              DescriptionField(
                label: "توضیحات پرداخت",
                  controller: descriptionController,
                  id: "payment",
                  show: showDes,
                soloDes: true,
                onPress: (){
                    showDes=!showDes;
                    setState(() {});
              },
              ),
              const Gap(20),
            ],
          ),
        ));
  }
}
