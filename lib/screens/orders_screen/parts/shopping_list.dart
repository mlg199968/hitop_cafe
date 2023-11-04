import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hitop_cafe/common/widgets/custom_tile.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/item.dart';
import 'package:persian_number_utility/persian_number_utility.dart';


class ShoppingList extends StatelessWidget {
  const ShoppingList({
    super.key,
    required this.items,
    required this.onChange,
  });

  final List<Item> items;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .4,
      width: double.maxFinite,
      decoration: kBoxDecoration,
      child: items.isEmpty
          ? const Center(child: Text("کالایی افزوده نشده است"))
          : SlidableAutoCloseBehavior(
              closeWhenOpened: true,
              child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    if (items[index].sum < 0) {
                    }
                    return CustomTile(
                      // onInfo: () {
                      //   showDialog(
                      //     context: context,
                      //     builder: (context) =>
                      //         WareToBillPanel(oldPurchase: items[index]),
                      //   ).then((value) => onChange());
                      // },
                      onDelete: () {
                        items.removeAt(index);
                        onChange();
                      },
                      height: 55,
                      color:Colors.brown.shade200,
                      leadingIcon: FontAwesomeIcons.cartShopping,
                      type: "item",
                      title: items[index].itemName,
                      subTitle:
                          "${items[index].quantity} ${items[index].unit} * ${addSeparator(items[index].sale)} "
                              .toPersianDigit(),
                      topTrailing: items[index].discount == 0
                          ? "ندارد"
                          : "${addSeparator(items[index].sum * (items[index].discount ?? 0)/100)} "
                              .toPersianDigit(),
                      topTrailingLabel: "تخفیف: ",
                      trailing: addSeparator(items[index].sum),
                    );
                  }),
            ),
    );
  }
}
