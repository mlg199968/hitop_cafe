import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/providers/ware_provider.dart';
import 'package:hitop_cafe/screens/orders_screen/quick_add_screen.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:provider/provider.dart';

class ItemSelectionPart extends StatefulWidget {
  const ItemSelectionPart(
      {super.key, required this.onChange, required this.selectedItems});
  final List<Item> selectedItems;
  final VoidCallback onChange;
  @override
  State<ItemSelectionPart> createState() => _ItemSelectionPartState();
}

class _ItemSelectionPartState extends State<ItemSelectionPart> {
  TextEditingController searchGroupController = TextEditingController();

  TextEditingController searchItemController = TextEditingController();

  String selectedGroup = "همه";

  String searchGroupWord = "";

  String searchItemWord = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 9, right: 9),
      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
          color: Colors.white24,

      ),
      width: 800,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///group list choose part
          Container(
            alignment: Alignment.center,
            height: 50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    "همه",
                    ...context.watch<WareProvider>().itemCategories
                  ].map((group) {
                    if (group.toString().contains(searchGroupWord)) {
                      return LabelTile(
                        activeColor: Colors.teal,
                        disableColor: Colors.blueGrey,
                        elevation: 0,
                        disable: selectedGroup != group,
                        fontSize: 11,
                        label: group,
                        onTap: () {
                          selectedGroup = group;
                          setState(() {});
                        },
                      );
                    } else {
                      return const SizedBox();
                    }
                  }).toList(),
                ),
              ),
            ),
          ),

          ///search item
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "انتخاب آیتم:",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),

                ///search group textField
                CustomTextField(
                  hint: "جست و جو آیتم",
                  height: 25,
                  borderRadius: 20,
                  controller: searchItemController,
                  suffixIcon: const Icon(Icons.search),
                  onChange: (val) {
                    searchItemWord = val;
                    setState(() {});
                  },
                ),
              ],
            ),
          ),

          ///choose item list  section
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Wrap(
              direction: Axis.horizontal,
              children: HiveBoxes.getItem().values.map((item) {
                if ((selectedGroup == item.category ||
                        selectedGroup == "همه") &&
                    item.itemName.contains(searchItemWord)) {
                  bool existCondition=widget.selectedItems
                      .map((e) => e.itemId)
                      .contains(item.itemId);
                  return LabelTile(
                    disable: !existCondition,
                    elevation: existCondition?0.6:0.3,
                    fontSize:existCondition?14:12 ,
                    count: !existCondition
                        ? 0
                        : widget.selectedItems
                            .firstWhere((element) =>
                                element.itemName == item.itemName)
                            .quantity,
                    label: item.itemName,
                    onTap: () {
                      bool existedItem = false;
                      for (var element in widget.selectedItems) {
                        if (element.itemName == item.itemName) {
                          element.quantity++;
                          existedItem = true;
                          widget.onChange();
                        }
                      }
                      if (!existedItem) {
                        item.quantity = 1;
                        widget.selectedItems.add(item);
                        widget.onChange();
                      }

                      setState(() {});
                    },
                    onSecondaryTap: () {
                      for (int i = 0;
                          i < widget.selectedItems.length;
                          i++) {
                        Item element = widget.selectedItems[i];
                        if (element.itemName == item.itemName) {
                          element.quantity > 1
                              ? element.quantity--
                              : widget.selectedItems.removeAt(i);
                          widget.onChange();
                        }
                      }

                      setState(() {});
                    },
                  );
                } else {
                  return const SizedBox();
                }
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
