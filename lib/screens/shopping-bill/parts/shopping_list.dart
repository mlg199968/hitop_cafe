import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/common/widgets/custom_tile.dart';
import 'package:hitop_cafe/common/widgets/empty_holder.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/purchase.dart';

import 'package:persian_number_utility/persian_number_utility.dart';


class ShoppingRawList extends StatefulWidget {
   const ShoppingRawList({
    super.key,
    required this.wares,
    required this.onChange,
  });

  final List<Purchase> wares;
  final VoidCallback onChange;

  @override
  State<ShoppingRawList> createState() => _ShoppingRawListState();
}

class _ShoppingRawListState extends State<ShoppingRawList> {
  bool isCollapse = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          gradient: kBlackWhiteGradiant,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [BoxShadow(offset: Offset(1, 3),blurRadius: 5,color: Colors.black54)]
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
              child: widget.wares.isEmpty
                  ?  const EmptyHolder(text:"آیتمی افزوده نشده است",icon:FontAwesomeIcons.boxOpen,)
                  : SlidableAutoCloseBehavior(
                      closeWhenOpened: true,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:
                          List.generate(widget.wares.length,(index) {
                                bool isNegative = false;
                                if (widget.wares[index].sum < 0) {
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
                                    widget.wares.removeAt(index);
                                    widget.onChange();
                                  },
                                  height: 55,
                                  color: isNegative ? Colors.redAccent : Colors.indigoAccent,
                                  leadingIcon: FontAwesomeIcons.cartShopping,
                                  type: (index+1).toString(),
                                  title: widget.wares[index].wareName,
                                  subTitle:
                                      "${widget.wares[index].quantity} ${widget.wares[index].unit} * ${addSeparator(widget.wares[index].price)} "
                                          .toPersianDigit(),
                                  topTrailing:"",
                                  topTrailingLabel: "تخفیف: ",
                                  trailing: addSeparator(widget.wares[index].sum),
                                );
                              }),

                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
