import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/common/widgets/drop_list_model.dart';
import 'package:hitop_cafe/common/widgets/image_picker_holder.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/providers/ware_provider.dart';
import 'package:hitop_cafe/screens/items_screen/panels/add_ingredient_panel.dart';
import 'package:hitop_cafe/screens/items_screen/panels/create_item_group_panel.dart';
import 'package:hitop_cafe/screens/items_screen/services/item_tools.dart';
import 'package:hitop_cafe/screens/items_screen/widgets/item_image_holder.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/widgets/action_button.dart';

import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../models/item.dart';
import '../../models/raw_ware.dart';

class AddItemScreen extends StatefulWidget {
  static const String id = "/add-item-screen";
  const AddItemScreen({Key? key, this.oldItem}) : super(key: key);
  final Item? oldItem;

  @override
  State<AddItemScreen> createState() => _AddWareScreenState();
}

class _AddWareScreenState extends State<AddItemScreen> {
  late WareProvider wareProvider;
  late UserProvider userProvider;
  final _formKey = GlobalKey<FormState>();
  TextEditingController itemNameController = TextEditingController();
  FocusNode wareNameFocus = FocusNode();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String unitItem = unitList[0];
  String? imagePath;
  List<RawWare> ingredients = [];


  ///save ware on local storage
  void saveItem({String? id}) async{
    Item item = Item(
      itemName: itemNameController.text,
      unit: unitItem,
      category: wareProvider.selectedItemCategory,
      sale: salePriceController.text.isEmpty
          ? 0
          : stringToDouble(salePriceController.text),
      description:
          descriptionController.text.isEmpty ? "" : descriptionController.text,
      itemId:id ?? const Uuid().v1() ,
      createDate: id != null ? widget.oldItem!.createDate : DateTime.now(),
      modifiedDate: DateTime.now(),
      ingredients: ingredients,
      imagePath: imagePath,
    );
    //save image if exist
    if(imagePath!=item.imagePath) {
      item.imagePath=await ItemTools.saveImage(imagePath, item.itemId);
    }
     HiveBoxes.getItem().put(item.itemId, item);
  }

  void restoreOldItem() {
    itemNameController.text = widget.oldItem!.itemName;
    salePriceController.text = addSeparator(widget.oldItem!.sale);
    descriptionController.text = widget.oldItem!.description;
    wareProvider.selectedItemCategory = widget.oldItem!.category;
    unitItem = widget.oldItem!.unit;
    ingredients = widget.oldItem!.ingredients;
    imagePath=widget.oldItem!.imagePath;
  }

  ///calculate the how much cost to create each item
  String calculateCost(List<RawWare> rawList) {
    double cost = 0;
    for (var ware in rawList) {
      cost += (ware.cost * ware.demand);
    }
    return " ${addSeparator(cost)} ${userProvider.currency}";
  }

  @override
  void initState() {
    wareProvider = Provider.of<WareProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    wareProvider.loadCategories();
    wareNameFocus.requestFocus();
    if (widget.oldItem != null) {
      restoreOldItem();
    }
    super.initState();
  }

  @override
  void dispose() {
    itemNameController.dispose();
    salePriceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: kMainGradiant),
        ),
        title: Text(widget.oldItem == null ? "افزودن آیتم" : "اصلاح آیتم"),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Consumer2<WareProvider, UserProvider>(
            builder: (context, wareProvider, userProvider, child) {
          return Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              width: 450,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Container(
                            ///photo part
                            height: 150,
                            margin: const EdgeInsets.all(5),
                            child: ItemImageHolder(
                              imagePath: imagePath,
                              onSet: (path){
                                imagePath=path;
                                setState(() {});
                              },
                                onEdited: (){
                                setState(() {});
                                },
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          ///select group dropdown list and add group
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              DropListModel(
                                  listItem: wareProvider.itemCategories,
                                  selectedValue:
                                      wareProvider.selectedItemCategory,
                                  onChanged: (val) {
                                    wareProvider
                                        .updateSelectedItemCategory(val);
                                  }),
                              CustomButton(
                                  text: "افزودن گروه",
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            CreateItemCategoryPanel());
                                  }),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            label: "نام آیتم",
                            controller: itemNameController,
                            focus: wareNameFocus,
                            validate: true,
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          ///unit dropdown list selection
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              DropListModel(
                                height: 35,
                                selectedValue: unitItem,
                                listItem: unitList,
                                onChanged: (val) {
                                  unitItem = val;
                                  setState(() {});
                                },
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            label: "قیمت فروش",
                            controller: salePriceController,
                            textFormat: TextFormatter.price,
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          ///ingredients part
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "مواد تشکیل دهنده",
                                style: TextStyle(fontSize: 16),
                              ),
                              ActionButton(
                                  label: "افزودن ماده جدید",
                                  bgColor: Colors.brown,
                                  onPress: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            AddIngredientPanel()).then((value) {
                                      if (value != null) {
                                        ingredients.add(value);
                                        setState(() {});
                                      }
                                    });
                                  },
                                  icon: FontAwesomeIcons.plus),
                            ],
                          ),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: kMainColor)),
                              padding: const EdgeInsets.all(9),
                              child: Column(
                                children: [
                                  Wrap(
                                    spacing: 20,
                                    children: List.generate(
                                        ingredients.length,
                                        (index) => RawRow(
                                              ingredients: ingredients,
                                              index: index,
                                              onReload: () {
                                                setState(() {});
                                              },
                                            )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.all(7),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("قیمت تمام شده :"),
                                Text(calculateCost(ingredients)),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          CustomTextField(
                            label: "توضیحات",
                            controller: descriptionController,
                            maxLine: 4,
                          ),
                        ],
                      ),
                    ),
                    CustomButton(
                        text: widget.oldItem == null
                            ? "افزودن به لیست"
                            : "ذخیره تغییرات",
                        width: MediaQuery.of(context).size.width,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (widget.oldItem != null) {
                              saveItem(id: widget.oldItem!.itemId);
                              Navigator.pop(context, false);
                            } else {
                              ///condition for demo mode
                              if (HiveBoxes.getItem().values.length <
                                  userProvider.ceilCount) {
                                saveItem();
                                showSnackBar(context, "آیتم به لیست افزوده شد!",
                                    type: SnackType.success);
                                itemNameController.clear();
                                salePriceController.clear();
                                descriptionController.clear();
                                ingredients.clear();
                                FocusScope.of(context)
                                    .requestFocus(wareNameFocus);
                                setState(() {});
                                // Navigator.pop(context,false);
                              } else {
                                showSnackBar(context, ceilCountMessage,
                                    type: SnackType.error);
                              }
                            }
                          }

                          setState(() {});
                        }),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class RawRow extends StatelessWidget {
  const RawRow({
    super.key,
    required this.index,
    required this.ingredients,
    required this.onReload,
  });
  final int index;
  final List<RawWare> ingredients;
  final VoidCallback onReload;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
          color: Colors.brown.shade50, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Text(ingredients[index].wareName),
          const VerticalDivider(),
          Text(
            ingredients[index].demand.toString(),
            style: const TextStyle(color: Colors.black38),
          ),
          Text(
            ingredients[index].unit,
            style: const TextStyle(color: Colors.black26),
          ),
          const Expanded(
              child: SizedBox(
            width: 10,
          )),
          IconButton(
            padding: const EdgeInsets.all(0),
            color: Colors.red,
            icon: const Icon(
              Icons.delete,
            ),
            onPressed: () {
              ingredients.removeAt(index);
              onReload();
            },
          ),
        ],
      ),
    );
  }
}
