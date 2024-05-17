import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/common/widgets/custom_tile.dart';
import 'package:hitop_cafe/common/widgets/empty_holder.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/screens/orders_screen/panels/item_to_bill_panel.dart';
import 'package:hitop_cafe/screens/orders_screen/quick_add_screen.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({
    super.key,
    required this.items,
    required this.onChange,
  });

  final List<Item> items;
  final VoidCallback onChange;

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
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
        // boxShadow: const [BoxShadow(offset: Offset(1, 3),blurRadius: 5,color: Colors.black54)]
      ),
      child: Column(
        children: [
          InkWell(
            onTap:(){
        isCollapse=!isCollapse;
        setState(() {});
      },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide())),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CText(
                    "لیست خرید",
                    fontSize: 17,
                  ),
                  const Gap(4),
                  CText(
                    addSeparator(widget.items.isEmpty?0:widget.items.map((e) => e.sum).reduce((a, b) => a+b)),
                    fontSize: 13,
                  ),
                  const Expanded(child: SizedBox()),
                  CText(
                    widget.items.length.toString().toPersianDigit(),
                    fontSize: 13,
                  ),
                  Icon(isCollapse
                          ? Icons.keyboard_arrow_down_rounded
                          : Icons.keyboard_arrow_up_rounded,),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 500),
            child: SizedBox(
              height: isCollapse?MediaQuery.of(context).size.height * .4:null,
              child: widget.items.isEmpty
                  ? const EmptyHolder(text:"آیتمی افزوده نشده است",icon: Icons.fastfood,)
                  : SlidableAutoCloseBehavior(
                      closeWhenOpened: true,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(widget.items.length, (index) {
                            return CustomTile(
                              onInfo: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      ItemToBillPanel(oldItem: widget.items[index]),
                                ).then((value) {
                                  if (value != null) {
                                    widget.items[index] = value;

                                    // items.removeAt(index);
                                    // items.insert(index, value);
                                  }
                                  widget.onChange();
                                });
                              },
                              onDelete: () {
                                widget.items.removeAt(index);
                                widget.onChange();
                              },
                              height: 55,
                              color: kMainColor,

                              ///
                              middleWidget: AddOrSubtract(
                                value: widget.items[index].quantity,
                                onChange: (val) {
                                  widget.items[index].quantity = val;
                                  if (widget.items[index].quantity < 1) {
                                    widget.items.removeAt(index);
                                  }
                                  widget.onChange();
                                },
                              ),

                              ///
                              leadingIcon: FontAwesomeIcons.cartShopping,

                              ///
                              type: (index + 1).toString().toPersianDigit(),

                              ///
                              title: widget.items[index].itemName,

                              ///
                              subTitle:
                                  "${widget.items[index].quantity} ${widget.items[index].unit} * ${addSeparator(widget.items[index].sale)} "
                                      .toPersianDigit(),

                              ///
                              topTrailing: widget.items[index].discount == 0
                                  ? "ندارد"
                                  : "${addSeparator(widget.items[index].sum * (widget.items[index].discount ?? 0) / 100)} "
                                      .toPersianDigit(),

                              ///
                              topTrailingLabel: "تخفیف: ",

                              ///
                              trailing: addSeparator(widget.items[index].sum),
                            );
                          }).reversed.toList(),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}


