import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hitop_cafe/common/widgets/custom_alert.dart';
import 'package:hitop_cafe/common/widgets/custom_float_action_button.dart';
import 'package:hitop_cafe/common/widgets/custom_search_bar.dart';
import 'package:hitop_cafe/common/widgets/custom_tile.dart';
import 'package:hitop_cafe/common/widgets/drop_list_model.dart';
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

  const ItemsScreen({Key? key}) : super(key: key);

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
    return LayoutBuilder(
        builder: (context,constraint){
          bool isTablet=constraint.maxWidth>500;
          return Consumer<WareProvider>(
              builder: (context,wareProvider,child) {
                return Scaffold(
                  key: scaffoldKey,
                  floatingActionButton: CustomFloatActionButton(onPressed: () {
                    Navigator.pushNamed(context, AddItemScreen.id);
                  }),
                  appBar:isTablet ? null : AppBar(
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    leading: isTablet && widget.key==null ? null:const BackButton(),
                    flexibleSpace: Container(
                      decoration:  BoxDecoration(gradient: kMainGradiant,borderRadius: isTablet && widget.key==null ?BorderRadius.circular(20):null,
                      ),
                    ),
                    actions: const [
                      // IconButton(
                      //     onPressed: () {
                      //       showDialog(
                      //           context: context,
                      //           builder: (context) => WareActionsPanel(
                      //             wares: waresList,
                      //             subGroup: selectedCategory,
                      //           ));
                      //     },
                      //     icon: const Icon(Icons.more_vert)),
                    ],
                    title: Container(
                      padding: const EdgeInsets.only(right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          screenType(context)!=ScreenType.mobile?const SizedBox(): const Text("کالا ها"),

                          ///dropDown list for Group Select
                          Flexible(
                            child: DropListModel(
                              selectedValue: selectedCategory,
                              height: 40,
                              listItem: ["همه", ...wareProvider.itemCategories],
                              onChanged: (val) {
                                selectedCategory = val;
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration:  BoxDecoration(
                          gradient: kMainGradiant,
                          borderRadius:isTablet && widget.key==null ?BorderRadius.circular(20):null,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            widget.key==null ?const SizedBox(): const BackButton(color: Colors.white,),
                            ///search bar
                            Expanded(
                              child: CustomSearchBar(
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
                            ),
                            ///dropDown list for Group Select on desktop mode
                            SizedBox(
                              child: !isTablet ?null: DropListModel(
                                selectedValue: selectedCategory,
                                height: 40,
                                listItem: ["همه", ...wareProvider.itemCategories],
                                onChanged: (val) {
                                  selectedCategory = val;
                                  setState(() {});
                                },
                              ),
                            ),
                            ///more icon button on desktop mode
                            // SizedBox(
                            //     child:constraint.maxWidth<550?null: IconButton(
                            //         onPressed: () {
                            //           showDialog(
                            //               context: context,
                            //               builder: (context) => WareActionsPanel(
                            //                 wares: waresList,
                            //                 subGroup: selectedCategory,
                            //               ));
                            //         },
                            //         icon: const Icon(Icons.more_vert,color: Colors.white,))
                            // ),
                          ],
                        ),
                      ),

                      ///get ware list
                      ValueListenableBuilder<Box<Item>>(
                          valueListenable: HiveBoxes.getItem().listenable(),
                          builder: (context, box, _) {

                            waresList = box.values.toList().cast<Item>();
                            List<Item> filteredList = ItemTools.filterList(waresList, keyWord, sortItem);

                            if (filteredList.isEmpty) {
                              return const Expanded(
                                child: Center(
                                    child: Text(
                                      "کالایی یافت نشد!",
                                      textDirection: TextDirection.rtl,
                                    )),
                              );
                            }
                            return ListPart(
                              key: widget.key,
                              category: selectedCategory,
                              wareList: filteredList,
                            );
                          }),
                    ],
                  ),
                );
              }
          );
        });
  }
}






class ListPart extends StatefulWidget {
  const ListPart({super.key, required this.wareList, required this.category});

  final List<Item> wareList;
  final String category;

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
      onWillPop:selectedItems.isEmpty?null: ()async{
        selectedItems.clear();
        setState(() {});
        return false;
      },
      child: Expanded(
        child: LayoutBuilder(
            builder: (context,constraint){
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  screenType(context)!=ScreenType.desktop?const SizedBox():Flexible(
                    child: SizedBox(
                      width: 400,
                      child:selectedWare==null? null: itemInfoPanelDesktop(
                          context: context,
                          wareInfo: selectedWare!,
                          onReload:(){
                            selectedWare=null;
                            setState(() {});}),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                              controller: ScrollController(),
                              itemCount: widget.wareList.length,
                              itemBuilder: (context, index) {
                                Item ware = widget.wareList[index];
                                if (widget.category ==
                                    widget.wareList[index].category ||
                                    widget.category == "همه") {
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
                                          selectedWare=ware;
                                          setState(() {});
                                          screenType(context)==ScreenType.desktop?null:showDialog(
                                              context: context,
                                              builder: (context) => itemInfoPanel(
                                                  context: context,
                                                  wareInfo: ware));
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
                                      leadingIcon: Icons.emoji_food_beverage_rounded,
                                      subTitle: ware.category,
                                      type: (index+1).toString().toPersianDigit(),
                                      title: ware.itemName,

                                      trailing: addSeparator(ware.sale), topTrailing: '',
                                    ),
                                  );
                                }
                                return const SizedBox();
                              }),
                        ),

                        ///selected items action bottom bar
                        Opacity(
                          opacity: selectedItems.isNotEmpty ? 1 : 0,
                          child: Container(
                            decoration: const BoxDecoration(
                                border:
                                Border(top: BorderSide(color: Colors.black87))),
                            height: selectedItems.isNotEmpty ? 50 : 0,
                            width: double.maxFinite,
                            child: Row(
                              children: [
                                ///delete icon
                                IconButton(
                                    onPressed: () {
                                      customAlert(
                                          context: context,
                                          title:
                                          "آیا از حذف موارد انتخاب شده مطمئن هستید؟",
                                          onYes: () {
                                            for (int item in selectedItems) {
                                              widget.wareList[item].delete();
                                            }
                                            showSnackBar(context,
                                                " ${selectedItems.length} کالا حذف شد!  ",
                                                type: SnackType.success);
                                            selectedItems.clear();
                                            Navigator.pop(context);
                                          },
                                          onNo: () {
                                            Navigator.pop(context);
                                          });
                                    },
                                    icon: const Icon(
                                      Icons.delete_forever,
                                      size: 35,
                                      color: Colors.red,
                                    )),
                                const VerticalDivider(),

                                ///print icon
                                IconButton(
                                    onPressed: () async {
                                      // List<Item> selectedList = [];
                                      // for (int item in selectedItems) {
                                      //   selectedList.add(widget.wareList[item]);
                                      // }
                                      // final file = await PdfWareListApi.generate(
                                      //     selectedList, context);
                                      // PdfApi.openFile(file);
                                    },
                                    icon: const Icon(
                                      CupertinoIcons.printer_fill,
                                      size: 30,
                                      color: Colors.black87,
                                    )),
                                const VerticalDivider(),

                                ///edit selected icon
                                IconButton(
                                    onPressed: () {
                                      // List<Item> selectedList = [];
                                      // for (int item in selectedItems) {
                                      //   selectedList.add(widget.wareList[item]);
                                      // }
                                      // showDialog(
                                      //     context: context,
                                      //     builder: (context) =>
                                      //         SelectedWareActionPanel(
                                      //             wares: selectedList));
                                    },
                                    icon: const Icon(
                                      FontAwesomeIcons.filePen,
                                      size: 30,
                                      color: Colors.black87,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
