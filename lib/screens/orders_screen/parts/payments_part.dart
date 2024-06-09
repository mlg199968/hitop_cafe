import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/common/widgets/custom_tile.dart';
import 'package:hitop_cafe/common/widgets/empty_holder.dart';
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
        // gradient: kBlackWhiteGradiant,
        color: Colors.white70,
        borderRadius: BorderRadius.circular(5),
        // boxShadow: const [BoxShadow(offset: Offset(1, 3), blurRadius: 5, color: Colors.black54)],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              isCollapse = !isCollapse;
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
                   const Gap(4),
                   CText(
                     addSeparator(widget.payments.isEmpty?0:widget.payments.map((e) => e.amount).reduce((a, b) => a+b)),
                    fontSize: 13,
                                       ),
                  const Expanded(child: SizedBox()),
                  CText(
                    widget.payments.length.toString().toPersianDigit(),
                    fontSize: 13,
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
              height:
                  isCollapse ? MediaQuery.of(context).size.height * .2 : null,
              child: widget.payments.isEmpty
                  ? const EmptyHolder(
                      text: "هنوز پرداختی صورت نگرفته",
                      icon: Icons.payment_rounded)
                  : SingleChildScrollView(
                    child: Column(
                        children:
                            List.generate(widget.payments.length, (index) {
                          Payment pay = widget.payments[index];

                          return CustomTile(
                              leadingIcon: pay.method == PayMethod.atm
                                  ? Icons.atm_rounded
                                  : pay.method == PayMethod.cash
                                      ? FontAwesomeIcons.moneyBill1Wave
                                      : pay.method == PayMethod.card
                                          ? FontAwesomeIcons.creditCard
                                          : Icons.discount_rounded,
                              onDelete: () {
                                widget.payments.removeAt(index);
                                widget.onChange();
                              },
                              height: 60,
                              color: Colors.teal,
                              type: (index + 1).toString().toPersianDigit(),
                              title: pay.method == PayMethod.atm
                                  ? "پرداخت با کارتخوان"
                                  : pay.method == PayMethod.cash
                                      ? "پرداخت نقدی"
                                      : pay.method == PayMethod.card
                                          ? "کارت به کارت"
                                          : "تخفیف",
                              subTitle: pay.description,
                              topTrailing: "",
                              trailing: addSeparator(pay.amount));
                        }).reversed.toList(),
                      ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
