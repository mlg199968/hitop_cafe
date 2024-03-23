import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_alert.dart';
import 'package:hitop_cafe/common/widgets/custom_float_action_button.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/common/widgets/hide_keyboard.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/providers/ware_provider.dart';
import 'package:hitop_cafe/screens/items_screen/services/item_tools.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:provider/provider.dart';

class QuickAddScreen extends StatefulWidget {
  static const String id = "quick-add-screen";
  const QuickAddScreen({super.key});

  @override
  State<QuickAddScreen> createState() => _QuickAddScreenState();
}

class _QuickAddScreenState extends State<QuickAddScreen> {
  final searchGroupController = TextEditingController();
  final searchItemController = TextEditingController();
  String selectedGroup = "همه";
  String searchGroupWord = "";
  String searchItemWord = "";
  List<Item> selectedItems = [];

  ///call message on pop to previous page function
  Future<bool> willPop() async {
    return await showDialog(
        context: context,
        builder: (context) => CustomAlert(
            title: "آیتم های انتخاب شده به فاکتور افزوده شود؟",
            onYes: () {
              Navigator.pop(context, false);
              Navigator.pop(
                  context,
                  selectedItems
                      .map((e) => ItemTools.copyToNewItem(e))
                      .toList());
            },
            onNo: () {
              Navigator.pop(context, false);
              Navigator.pop(context);
            }));
  }

  @override
  void dispose() {
    for (var element in selectedItems) {
      element.quantity = 1;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: selectedItems.isNotEmpty ? willPop : null,
      child: HideKeyboard(
        child: Scaffold(
          floatingActionButton: CustomFloatActionButton(
              label: "افزودن به فاکتور",
              icon: Icons.arrow_back,
              bgColor: kSecondaryColor,
              onPressed: () {
                //Because the models in the list are selected directly from the box,
                //so that the imported models do not interfere, we will replace them with the new model.
                Navigator.pop(
                    context,
                    selectedItems
                        .map((e) => ItemTools.copyToNewItem(e))
                        .toList());
              }),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Center(child: Text("منو افزودن سریع")),
          ),
          extendBodyBehindAppBar: true,
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                gradient: kMainGradiant,
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: 500,
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
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 17),
                              ),

                              ///search group textField
                              CustomTextField(
                                hint: "جست و جو گروه",
                                height: 30,
                                borderRadius: 20,
                                controller: searchGroupController,
                                suffixIcon: const Icon(Icons.search),
                                onChange: (val) {
                                  searchGroupWord = val;
                                  setState(() {});
                                },
                              ),
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
                                  ...context
                                      .watch<WareProvider>()
                                      .itemCategories
                                ].map((group) {
                                  if (group
                                      .toString()
                                      .contains(searchGroupWord)) {
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
                                  } else {
                                    return const SizedBox();
                                  }
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "انتخاب آیتم:",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 17),
                              ),

                              ///search group textField
                              CustomTextField(
                                hint: "جست و جو آیتم",
                                height: 30,
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
                        Container(
                          alignment: Alignment.center,
                          width: double.maxFinite,
                          margin: const EdgeInsets.only(left: 9, right: 9),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                              gradient: kBlackWhiteGradiant,
                              borderRadius: BorderRadius.circular(20)),
                          height: MediaQuery.of(context).size.height * .3,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Wrap(
                                direction: Axis.horizontal,
                                children:
                                    HiveBoxes.getItem().values.map((item) {
                                  if ((selectedGroup == item.category ||
                                          selectedGroup == "همه") &&
                                      item.itemName.contains(searchItemWord)) {
                                    return LabelTile(
                                      disable: !selectedItems.contains(item),
                                      count: !selectedItems.contains(item)
                                          ? 0
                                          : selectedItems
                                              .firstWhere((element) =>
                                                  element.itemName ==
                                                  item.itemName)
                                              .quantity,
                                      label: item.itemName,
                                      onTap: () {
                                        bool existedItem = false;
                                        for (var element in selectedItems) {
                                          if (element.itemName ==
                                              item.itemName) {
                                            element.quantity++;
                                            existedItem = true;
                                          }
                                        }
                                        if (!existedItem) {
                                          selectedItems.add(item);
                                        }

                                        setState(() {});
                                      },
                                      onSecondaryTap: () {
                                        for (int i = 0;
                                            i < selectedItems.length;
                                            i++) {
                                          Item element = selectedItems[i];
                                          if (element.itemName ==
                                              item.itemName) {
                                            element.quantity > 1
                                                ? element.quantity--
                                                : selectedItems.removeAt(i);
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
                        const Divider(
                          height: 50,
                          indent: 50,
                          endIndent: 50,
                        ),

                        ///selected items list
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: selectedItems
                                .map(
                                  (item) => QuickItemTile(
                                    label: item.itemName,
                                    count: item.quantity,
                                    onChange: (val) {
                                      item.quantity = val;
                                      if (item.quantity < 1) {
                                        selectedItems.remove(item);
                                      }
                                      setState(() {});
                                    },
                                  ),
                                )
                                .toList()
                                .reversed
                                .toList(),
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LabelTile extends StatelessWidget {
  const LabelTile({
    super.key,
    required this.label,
    this.count = 0,
    this.onTap,
    this.onSecondaryTap,
    this.disable = true,
    this.disableColor = kMainDisableColor,
    this.activeColor = kMainActiveColor,
  });
  final String label;
  final num count;
  final VoidCallback? onTap;
  final VoidCallback? onSecondaryTap;
  final bool disable;
  final Color activeColor;
  final Color disableColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onSecondaryTap: onSecondaryTap,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        child: Container(
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              color: disable ? disableColor : activeColor,
              borderRadius: BorderRadius.circular(disable ? 5 : 10)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  label,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const VerticalDivider(
                width: 5,
              ),
              if (count != 0)
                Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        color: Colors.white70, shape: BoxShape.circle),
                    child: Text(count.toString().toPersianDigit())),
            ],
          ),
        ),
      ),
    );
  }
}

///quick item list tile
class QuickItemTile extends StatelessWidget {
  const QuickItemTile({
    super.key,
    required this.label,
    this.count = 0,
    this.onTap,
    this.disable = true,
    this.disableColor = Colors.white,
    this.activeColor = kMainActiveColor,
    required this.onChange,
  });
  final String label;
  final num count;
  final VoidCallback? onTap;
  final Function(num count) onChange;
  final bool disable;
  final Color activeColor;
  final Color disableColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            color: disable ? disableColor : activeColor,
            borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                label,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const VerticalDivider(
              width: 5,
            ),

            ///counter
            if (count != 0)
              Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                    color: Colors.black, shape: BoxShape.circle),
                child: Text(
                  count.toString().toPersianDigit(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            const Expanded(child: SizedBox()),

            ///add and remove button
            AddOrSubtract(
              value: count,
              onChange: onChange,
            )
          ],
        ),
      ),
    );
  }
}

/// add and subtract button
class AddOrSubtract extends StatelessWidget {
  const AddOrSubtract({
    super.key,
    required this.value,
    required this.onChange,
  });

  final num value;
  final Function(num count) onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3),
      height: 30,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
              onTap: () {
                onChange(value - 1);
              },
              child: const Icon(
                CupertinoIcons.minus_rectangle_fill,
                size: 20,
                color: Colors.redAccent,
              )),
          const SizedBox(
            width: 3,
          ),
          InkWell(
              onTap: () {
                onChange(value + 1);
              },
              child: const Icon(
                CupertinoIcons.plus_rectangle_fill,
                size: 20,
                color: Colors.teal,
              )),
        ],
      ),
    );
  }
}
