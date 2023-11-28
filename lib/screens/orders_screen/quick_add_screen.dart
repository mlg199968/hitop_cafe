import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_float_action_button.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/providers/ware_provider.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class QuickAddScreen extends StatefulWidget {
  static const String id = "quick-add-screen";
  const QuickAddScreen({super.key});

  @override
  State<QuickAddScreen> createState() => _QuickAddScreenState();
}

class _QuickAddScreenState extends State<QuickAddScreen> {
  String selectedGroup = "همه";
  List<Item> selectedItems = [];

  @override
  void dispose() {
    selectedItems.forEach((element) {element..quantity=1..itemId=Uuid().v1();});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFloatActionButton(
          label: "افزودن به فاکتور",
          icon: Icons.arrow_back,
          bgColor: kSecondaryColor,
          onPressed: () {
            Navigator.pop(context,selectedItems);
          }),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Center(child: Text("منو افزودن سریع")),
      ),
      extendBodyBehindAppBar: true,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          alignment: Alignment.topRight,
          decoration: const BoxDecoration(
            gradient: kMainGradiant,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "انتخاب گروه:",
                      style: TextStyle(color: Colors.white70, fontSize: 17),
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
                                (group) => LabelTile(
                                  activeColor: Colors.teal,
                                  disableColor: Colors.blueGrey,
                                  disable: selectedGroup != group,
                                  label: group,
                                  onTap: () {
                                    selectedGroup = group;
                                    setState(() {});
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "انتخاب آیتم:",
                      style: TextStyle(color: Colors.white70, fontSize: 17),
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
                          children: HiveBoxes.getItem().values.map((item) {
                            if (selectedGroup == item.category ||
                                selectedGroup == "همه") {
                              return LabelTile(
                                disable: !selectedItems.contains(item),
                                count: !selectedItems.contains(item)
                                    ? 0
                                    : selectedItems
                                        .firstWhere((element) =>
                                            element.itemName == item.itemName)
                                        .quantity,
                                label: item.itemName,
                                onTap: () {
                                  bool existedItem = false;
                                  selectedItems.forEach((element) {
                                    if (element.itemName == item.itemName) {
                                      element.quantity++;
                                      existedItem = true;
                                    }
                                  });
                                  if (!existedItem) {
                                    selectedItems.add(item);
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
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: selectedItems
                          .map(
                            (item) => QuickItemTile(
                              label: item.itemName,
                              count: item.quantity,
                              onAddPress: () {
                                item.quantity++;
                                setState(() {});
                              },
                              onRemovePress: () {
                                if (item.quantity > 1) {
                                  item.quantity--;
                                } else {
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
    );
  }
}

class LabelTile extends StatelessWidget {
  const LabelTile({
    super.key,
    required this.label,
    this.count = 0,
    this.onTap,
    this.disable = true,
    this.disableColor = kMainDisableColor,
    this.activeColor = kMainActiveColor,
  });
  final String label;
  final num count;
  final VoidCallback? onTap;
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
    );
  }
}

class QuickItemTile extends StatelessWidget {
  const QuickItemTile({
    super.key,
    required this.label,
    this.count = 0,
    this.onTap,
    this.disable = true,
    this.disableColor = Colors.white,
    this.activeColor = kMainActiveColor,
    this.onAddPress,
    this.onRemovePress,
  });
  final String label;
  final num count;
  final VoidCallback? onTap;
  final VoidCallback? onAddPress;
  final VoidCallback? onRemovePress;
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
            Container(
              padding: const EdgeInsets.symmetric(vertical: 3),
              height: 30,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                      onTap: onRemovePress,
                      child: const CircleAvatar(
                          minRadius: 3,
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                          ))),
                  const SizedBox(
                    width: 3,
                  ),
                  InkWell(
                      onTap: onAddPress,
                      child: const CircleAvatar(
                          minRadius: 3,
                          backgroundColor: Colors.teal,
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
