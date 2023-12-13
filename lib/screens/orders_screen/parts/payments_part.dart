import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hitop_cafe/common/widgets/custom_tile.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/payment.dart';

// ignore: camel_case_types
class PaymentList extends StatelessWidget {
  const PaymentList(
      {super.key,
      required this.payments,
      required this.onChange});
  final List payments;

  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "لیست پرداخت",
            style: TextStyle(
                fontSize: 17, color: Colors.white),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * .2,
          width: 450,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white70)
          ),
          child: payments.isEmpty
              ? const Center(child: Text("هنوز پرداختی صورت نگرفته",style: TextStyle(color: Colors.white70),))
              : Column(
                  children: [
                    Flexible(
                      child: payments.isEmpty
                          ? const SizedBox()
                          : ListView.builder(
                              itemCount: payments.length,
                              itemBuilder: (context, index) {
                                Payment pay=payments[index];

                                  return CustomTile(
                                      leadingIcon:pay.method=="atm"? FontAwesomeIcons.creditCard:FontAwesomeIcons.moneyBill1Wave,
                                      onDelete: () {
                                        payments.removeAt(index);
                                        onChange();
                                      },
                                      height: 60,
                                      color: Colors.green,
                                      type: (index+1).toString(),
                                      title:pay.method=="atm"?"پرداخت با کارت": "پرداخت نقدی",
                                      topTrailing: "",
                                      trailing: addSeparator(pay.amount));
                                }

                              ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
