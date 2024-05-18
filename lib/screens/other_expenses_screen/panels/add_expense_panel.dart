import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/time/time.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/constants/consts_class.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/note.dart';
import 'package:hitop_cafe/models/payment.dart';
import 'package:hitop_cafe/screens/orders_screen/widgets/description_textfield.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:uuid/uuid.dart';

import '../../../common/widgets/custom_dialog.dart';
import '../../../common/widgets/custom_textfield.dart';

class AddExpensePanel extends StatefulWidget {
  const AddExpensePanel({super.key, this.oldExpense});
final Payment? oldExpense;
  @override
  State<AddExpensePanel> createState() => _AddExpensePanelState();
}

class _AddExpensePanelState extends State<AddExpensePanel> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();

replaceOldExpense(){
  if(widget.oldExpense!=null){
    Payment old=widget.oldExpense!;
    amountController.text=addSeparator(old.amount);
    titleController.text=old.description ?? "" ;
    setState(() {});
  }
}
@override
  void initState() {
    replaceOldExpense();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
        title: "افزودن هزینه",
        actions: [
          Expanded(
            child: CustomButton(
                width: 600,
                height: 30,
                text: "افزودن به لیست",
                onPressed: () {
                  if(_formKey.currentState!.validate()) {
                    Payment payment = Payment()
                      ..description = titleController.text
                      ..amount = stringToDouble(amountController.text)
                      ..method=PayMethod.other
                      ..deliveryDate = DateTime.now()
                      ..paymentId = widget.oldExpense!=null?widget.oldExpense!.paymentId:const Uuid().v1();
                    HiveBoxes.getExpenses().put(payment.paymentId, payment);
                    Navigator.pop(context, "");
                  }
                }),
          )
        ],
        child: Form(
          key:_formKey ,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                validate: true,
                label: "مبلغ",
                textFormat: TextFormatter.price,
                controller: amountController,
                maxLength: 20,
                maxLine: 1,
              ),
              const Gap(20),
              DescriptionField(
                label: "عنوان و توضیحات",
                maxLine: 5,
                show: true,
                showDropButton: false,
                soloDes: true,
                id: "expense",
                controller: titleController,
                onPress: (){

                },
              ),
              const Gap(5),
            ],
          ),
        ));
  }
}
