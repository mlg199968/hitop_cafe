import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hitop_cafe/common/widgets/custom_tile.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/purchase.dart';

import 'package:persian_number_utility/persian_number_utility.dart';


class ShoppingRawList extends StatelessWidget {
  const ShoppingRawList({
    super.key,
    required this.wares,
    required this.onChange,
  });

  final List<Purchase> wares;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "لیست خرید",
            style: TextStyle(
                fontSize: 17, color: Colors.white),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * .4,
          width: double.maxFinite,
          decoration:BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white70)
          ),
          child: wares.isEmpty
              ? const Center(child: Text("کالایی افزوده نشده است",style: TextStyle(color: Colors.white70),))
              : SlidableAutoCloseBehavior(
                  closeWhenOpened: true,
                  child: ListView.builder(
                      itemCount: wares.length,
                      itemBuilder: (context, index) {
                        bool isNegative = false;
                        if (wares[index].sum < 0) {
                          isNegative = true;
                        }
                        return CustomTile(
                          // onInfo: () {
                          //   showDialog(
                          //     context: context,
                          //     builder: (context) =>
                          //         WareToBillPanel(oldPurchase: wares[index]),
                          //   ).then((value) => onChange());
                          // },
                          onDelete: () {
                            wares.removeAt(index);
                            onChange();
                          },
                          height: 55,
                          color: isNegative ? Colors.red : Colors.blue,
                          leadingIcon: FontAwesomeIcons.cartShopping,
                          type: (index+1).toString(),
                          title: wares[index].wareName,
                          subTitle:
                              "${wares[index].quantity} ${wares[index].unit} * ${addSeparator(wares[index].price)} "
                                  .toPersianDigit(),
                          topTrailing:"",
                          topTrailingLabel: "تخفیف: ",
                          trailing: addSeparator(wares[index].sum),
                        );
                      }),
                ),
        ),
      ],
    );
  }
}
