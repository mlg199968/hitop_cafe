

import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/providers/ware_provider.dart';
import 'package:hitop_cafe/screens/orders_screen/quick_add_screen.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:provider/provider.dart';

class ItemSelectionPart extends StatefulWidget {
   const ItemSelectionPart({super.key, required this.onChange, required this.selectedItems});
  final List<Item> selectedItems;
final VoidCallback onChange;
  @override
  State<ItemSelectionPart> createState() => _ItemSelectionPartState();
}

class _ItemSelectionPartState extends State<ItemSelectionPart> {
  TextEditingController searchGroupController=TextEditingController();

  TextEditingController searchItemController=TextEditingController();

  String selectedGroup = "همه";

  String searchGroupWord="";

  String searchItemWord="";

@override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 800,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "انتخاب گروه:",
                  style: TextStyle(color: Colors.white70, fontSize: 17),
                ),
                ///search group textField
                CustomTextField(
                  hint: "جست و جو گروه",
                  height: 30,
                  borderRadius: 20,
                  controller: searchGroupController,
                  suffixIcon:const Icon(Icons.search),
                  onChange: (val){
                    searchGroupWord=val;
                    setState(() {});
                  },),
              ],
            ),
          ),

          ///group list choose part
          Container(
            alignment: Alignment.center,
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: const BoxDecoration(),
            height: 100,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Wrap(
                  direction: Axis.horizontal,
                  children: [
                    "همه",
                    ...context.watch<WareProvider>().itemCategories
                  ]
                      .map(
                          (group) {
                        if(group.toString().contains(searchGroupWord))
                        {
                          return LabelTile(
                            activeColor: Colors.teal,
                            disableColor: Colors.blueGrey,
                            disable: selectedGroup != group,
                            label: group,
                            onTap: () {
                              selectedGroup = group;
                              setState(() {});
                            },
                          );
                        }else{
                          return const SizedBox();
                        }
                      }
                  )
                      .toList(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween ,
              children: [
                const Text(
                  "انتخاب آیتم:",
                  style: TextStyle(color: Colors.white70, fontSize: 17),
                ),
                ///search group textField
                CustomTextField(
                  hint: "جست و جو آیتم",
                  height: 30,
                  borderRadius: 20,
                  controller: searchItemController,
                  suffixIcon:const Icon(Icons.search),
                  onChange: (val){
                    searchItemWord=val;
                    setState(() {});
                  },),
              ],
            ),
          ),

          ///choose item list  section
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(left: 9, right: 9),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                gradient: kBlackWhiteGradiant,
                borderRadius: BorderRadius.circular(7),
            boxShadow: const [BoxShadow(offset: Offset(1, 3),blurRadius: 5,color: Colors.black54)]),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Wrap(
                  direction: Axis.horizontal,
                  children: HiveBoxes.getItem().values.map((item) {
                    if ((selectedGroup == item.category ||
                        selectedGroup == "همه") && item.itemName.contains(searchItemWord)) {
                      return LabelTile(
                        disable: !widget.selectedItems.map((e)=>e.itemId).contains(item.itemId),
                        count: !widget.selectedItems.map((e)=>e.itemId).contains(item.itemId)
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
                            item.quantity=1;
                            widget.selectedItems.add(item);
                            widget.onChange();
                          }

                          setState(() {});
                        },
                        onSecondaryTap: () {
                          for (int i=0;i<widget.selectedItems.length;i++) {
                            Item element= widget.selectedItems[i];
                            if (element.itemName == item.itemName) {
                              element.quantity>1
                                  ?element.quantity--
                                  :
                              widget.selectedItems.removeAt(i);
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
            ),
          ),
        ],
      ),
    );
  }
}
