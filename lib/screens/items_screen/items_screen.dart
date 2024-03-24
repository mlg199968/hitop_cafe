import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_alert.dart';
import 'package:hitop_cafe/common/widgets/custom_appbar.dart';
import 'package:hitop_cafe/common/widgets/custom_float_action_button.dart';
import 'package:hitop_cafe/common/widgets/custom_icon_button.dart';
import 'package:hitop_cafe/common/widgets/custom_search_bar.dart';
import 'package:hitop_cafe/common/widgets/custom_tile.dart';
import 'package:hitop_cafe/common/widgets/drop_list_model.dart';
import 'package:hitop_cafe/common/widgets/empty_holder.dart';
import 'package:hitop_cafe/common/widgets/hide_keyboard.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/providers/ware_provider.dart';
import 'package:hitop_cafe/screens/items_screen/add_item_screen.dart';
import 'package:hitop_cafe/screens/items_screen/panels/item_info_panel.dart';
import 'package:hitop_cafe/screens/items_screen/services/item_tools.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import 'package:provider/provider.dart';

class ItemsScreen extends StatefulWidget {
  static const String id = "/items-screen";

  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _WareListScreenState();
}

class _WareListScreenState extends State<ItemsScreen> {
  TextEditingController searchController = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late List<Item> waresList;
  String selectedCategory = "همه";
  final List<String> sortList = [
    'تاریخ ثبت',
    'تاریخ ویرایش',
    'حروف الفبا',
  ];
  String sortItem = 'تاریخ ویرایش';
  String? keyWord;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Consumer<WareProvider>(builder: (context, wareProvider, child) {
        return HideKeyboard(
          child: Scaffold(
            key: scaffoldKey,
            floatingActionButton: CustomFloatActionButton(onPressed: () {
              Navigator.pushNamed(context, AddItemScreen.id);
            }),
            appBar: CustomAppBar(
              height: constraint.maxWidth < 800 ? 130 : 60,
              title: "آیتم ها",
              context2: context,
              widgets: [
                ///dropDown list for Group Select
                DropListModel(
                  selectedValue: selectedCategory,
                  height: 40,
                  listItem: ["همه", ...wareProvider.itemCategories],
                  onChanged: (val) {
                    selectedCategory = val;
                    setState(() {});
                  },
                ),

                ///search bar
                CustomSearchBar(
                  controller: searchController,
                  hint: "جست و جو کالا",
                  onChange: (val) {
                    keyWord = val;
                    setState(() {});
                  },
                  selectedSort: sortItem,
                  sortList: sortList,
                  onSort: (val) {
                    sortItem = val;
                    setState(() {});
                  },
                ),
              ],
            ),
            body: Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ///get item list
                  ValueListenableBuilder<Box<Item>>(
                      valueListenable: HiveBoxes.getItem().listenable(),
                      builder: (context, box, _) {
                        waresList = box.values.toList().cast<Item>();
                        List<Item> filteredList = ItemTools.filterList(
                            waresList, keyWord, sortItem, selectedCategory);

                        if (filteredList.isEmpty) {
                          return const Expanded(
                              child: EmptyHolder(
                                  text: "آیتمی یافت نشد!",
                                  icon: Icons.fastfood_rounded));
                        }
                        return ListPart(
                          key: widget.key,
                          wareList: filteredList,
                        );
                      }),
                ],
              ),
            ),
          ),
        );
      });
    });
  }
}

class ListPart extends StatefulWidget {
  const ListPart({super.key, required this.wareList});

  final List<Item> wareList;

  @override
  State<ListPart> createState() => _ListPartState();
}

class _ListPartState extends State<ListPart> {
  List<int> selectedItems = [];
  Item? selectedWare;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //if action bottom bar is shown,on will pop first close the action bar then on the second press close the screen
      onWillPop: selectedItems.isEmpty
          ? null
          : () async {
              selectedItems.clear();
              setState(() {});
              return false;
            },
      child: Expanded(
        child: LayoutBuilder(builder: (context, constraint) {
          bool widthCondition = constraint.maxWidth > 500;
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ///info panel on desktop
              if (widthCondition)
                Flexible(
                  child: SizedBox(
                      child: selectedWare == null
                          ? null
                          : ItemInfoPanelDesktop(
                              item: selectedWare!,
                              onDelete: () {
                                selectedWare = null;
                                setState(() {});
                              })),
                ),

              ///list part
              Flexible(
                child: SizedBox(
                  width: 550,
                  child: Stack(
                    children: [
                      ListView.builder(
                          controller: ScrollController(),
                          itemCount: widget.wareList.length,
                          itemBuilder: (context, index) {
                            Item ware = widget.wareList[index];

                            return InkWell(
                              onLongPress: () {
                                if (!selectedItems.contains(index)) {
                                  selectedItems.add(index);
                                  setState(() {});
                                }
                              },
                              onTap: () {
                                if (selectedItems.isEmpty) {
                                  if (widget.key != null) {
                                    Navigator.pop(context, ware);
                                  } else {
                                    selectedWare = ware;
                                    setState(() {});
                                    widthCondition
                                        ? null
                                        : showDialog(
                                            context: context,
                                            builder: (context) =>
                                                ItemInfoPanel(item: ware));
                                  }
                                } else {
                                  if (selectedItems.contains(index)) {
                                    selectedItems.remove(index);
                                  } else {
                                    selectedItems.add(index);
                                  }
                                  setState(() {});
                                }
                              },
                              child: CustomTile(
                                selected: selectedItems.contains(index),
                                enable: false,
                                onDelete: () {},
                                height: 50,
                                color: selectedItems.contains(index)
                                    ? Colors.blue
                                    : kMainColor,
                                surfaceColor:
                                    selectedWare == widget.wareList[index]
                                        ? kMainColor
                                        : null,
                                leadingIcon: Icons.emoji_food_beverage_rounded,
                                subTitle: ware.category,
                                type: (index + 1).toString().toPersianDigit(),
                                title: ware.itemName,
                                trailing: addSeparator(ware.sale),
                                topTrailing: '',
                              ),
                            );
                          }),

                      ///selected items action bottom bar
                      if (selectedItems.isNotEmpty)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),

                              // boxShadow: [kShadow]
                              border: Border.all(
                                color: Colors.black87,
                              ),
                            ),
                            height: selectedItems.isNotEmpty ? 50 : 0,
                            width: double.maxFinite,
                            child: BlurryContainer(
                              padding: EdgeInsets.zero,
                              child: Row(
                                children: [
                                  ///close icon
                                  CustomIconButton(
                                      onPress: () {
                                        selectedItems.clear();
                                        setState(() {});
                                      },
                                      icon:
                                        CupertinoIcons.multiply_circle,
                                        iconSize: 30,
                                    iconColor: Colors.black,
                                      ),
                                  const VerticalDivider(),
                                  ///delete icon
                                  CustomIconButton(
                                      onPress: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => CustomAlert(
                                                title:
                                                    "آیا از حذف موارد انتخاب شده مطمئن هستید؟",
                                                onYes: () {
                                                  for (int item
                                                      in selectedItems) {
                                                    widget.wareList[item]
                                                        .delete();
                                                  }
                                                  showSnackBar(context,
                                                      " ${selectedItems.length} کالا حذف شد!  ",
                                                      type: SnackType.success);
                                                  selectedItems.clear();
                                                  popFunction(context);
                                                },
                                                onNo: () {
                                                  popFunction(context);
                                                }));
                                      },
                                      icon:Icons.delete_forever,
                                        iconSize: 35,
                                        iconColor: Colors.red,
                                    showShadow: true,),
                                  Text(selectedItems.length.toString().toPersianDigit(),style: const TextStyle(fontSize: 20),),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
