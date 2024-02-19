import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/common/widgets/custom_tile.dart';
import 'package:hitop_cafe/common/widgets/empty_holder.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/consts_class.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/payment.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

// ignore: camel_case_types
class PaymentList extends StatefulWidget {
  const PaymentList(
      {super.key, required this.payments, required this.onChange});
  final List payments;

  final VoidCallback onChange;

  @override
  State<PaymentList> createState() => _PaymentListState();
}

class _PaymentListState extends State<PaymentList> {
  bool isCollapse = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          gradient: kBlackWhiteGradiant,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
                offset: Offset(1, 3), blurRadius: 5, color: Colors.black54)
          ]),
      child: Column(
        children: [
          InkWell(
            onTap:(){
              isCollapse=!isCollapse;
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration:
                  const BoxDecoration(border: Border(bottom: BorderSide())),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CText(
                    "لیست پرداخت",
                    fontSize: 17,
                  ),
                  Icon(
                    isCollapse
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_up_rounded,
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 500),
            child: SizedBox(
              height: isCollapse ? MediaQuery.of(context).size.height * .2 : null,
              child: widget.payments.isEmpty
                  ? const EmptyHolder(text: "هنوز پرداختی صورت نگرفته", icon: Icons.payment_rounded)
                  : Column(
                      children:
                        List.generate(widget.payments.length,(index) {
                                  Payment pay = widget.payments[index];

                                  return CustomTile(
                                      leadingIcon: pay.method == PayMethod.atm
                                          ? FontAwesomeIcons.creditCard
                                          : pay.method == PayMethod.cash?FontAwesomeIcons.moneyBill1Wave:Icons.discount_rounded,
                                      onDelete: () {
                                        widget.payments.removeAt(index);
                                        widget.onChange();
                                      },
                                      height: 60,
                                      color: Colors.teal,
                                      type: (index + 1).toString().toPersianDigit(),
                                      title: pay.method == PayMethod.atm
                                          ? "پرداخت با کارت"
                                          :pay.method == PayMethod.cash? "پرداخت نقدی":"تخفیف",
                                      topTrailing: "",
                                      trailing: addSeparator(pay.amount));
                                }).reversed.toList(),

                    ),
            ),
          ),
        ],
      ),
    );
  }
}
