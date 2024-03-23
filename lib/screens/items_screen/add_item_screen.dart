
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hitop_cafe/common/widgets/custom_float_action_button.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/common/widgets/drop_list_model.dart';
import 'package:hitop_cafe/common/widgets/hide_keyboard.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/consts_class.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/providers/ware_provider.dart';
import 'package:hitop_cafe/screens/items_screen/panels/add_ingredient_panel.dart';
import 'package:hitop_cafe/screens/items_screen/panels/create_item_group_panel.dart';
import 'package:hitop_cafe/screens/items_screen/widgets/item_image_holder.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/screens/user_screen/services/user_tools.dart';

import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../models/item.dart';
import '../../models/raw_ware.dart';

class AddItemScreen extends StatefulWidget {
  static const String id = "/add-item-screen";
  const AddItemScreen({super.key, this.oldItem});
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
  saveItem({String? id}) async{
    Item item = Item()
     ..itemName= itemNameController.text
     ..unit= unitItem
     ..category= wareProvider.selectedItemCategory
     ..sale= salePriceController.text.isEmpty
          ? 0
          : stringToDouble(salePriceController.text)
      ..description=
          descriptionController.text.isEmpty ? "" : descriptionController.text
      ..itemId=id ?? const Uuid().v1()
      ..createDate= id != null ? widget.oldItem!.createDate : DateTime.now()
      ..modifiedDate= DateTime.now()
      ..ingredients= ingredients
      ..imagePath= id==null?null:widget.oldItem!.imagePath;

    // save image if exist
    if(imagePath!=item.imagePath) {
      final String newPath = await Address.itemsImage();
      item.imagePath=await saveImage(imagePath, item.itemId,newPath);
    }
     HiveBoxes.getItem().put(item.itemId, item);
  }

  void restoreOldItem() async{
    ingredients=[];
    itemNameController.text = widget.oldItem!.itemName;
    salePriceController.text = addSeparator(widget.oldItem!.sale);
    descriptionController.text = widget.oldItem!.description;
    wareProvider.selectedItemCategory = widget.oldItem!.category;
    unitItem = widget.oldItem!.unit;
    ingredients.addAll(widget.oldItem!.ingredients);
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
  void didChangeDependencies() {
    wareNameFocus.unfocus();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    wareNameFocus.dispose();
    itemNameController.dispose();
    salePriceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
///************************************ widget tree ***************************************
  @override
  Widget build(BuildContext context) {
    // To hide the keyboard
    return HideKeyboard(
      child: Scaffold(
        floatingActionButtonLocation: screenType(context)==ScreenType.mobile?null:FloatingActionButtonLocation.centerFloat,
        floatingActionButton: CustomFloatActionButton(
          label: widget.oldItem == null
              ? "افزودن به لیست"
              : "ذخیره تغییرات",
            icon: Icons.check_rounded,
            onPressed: (){
              if (_formKey.currentState!.validate()) {
                if (widget.oldItem != null) {
                  saveItem(id: widget.oldItem!.itemId);
                  Navigator.pop(context, false);
                } else {
                  ///condition for demo mode
                  if (UserTools.userPermission(context,count: HiveBoxes.getItem().values.length)) {
                    saveItem();
                    showSnackBar(
                        context, "آیتم به لیست افزوده شد!",
                        type: SnackType.success);
                    itemNameController.clear();
                    salePriceController.clear();
                    descriptionController.clear();
                    imagePath = null;
                    ingredients=[];
                    // FocusScope.of(context)
                    //     .requestFocus(wareNameFocus);

                    setState(() {});
                    // Navigator.pop(context,false);
                  }
                }
              }

              setState(() {});
            }),
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: kMainGradiant),
          ),
          title: Text(widget.oldItem == null ? "افزودن آیتم" : "اصلاح آیتم"),
        ),
        body: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            gradient: kMainGradiant,
          ),
          child: SingleChildScrollView(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Consumer2<WareProvider, UserProvider>(
                  builder: (context, wareProvider, userProvider, child) {
                return Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: kBlackWhiteGradiant,
                        boxShadow: const [kShadow]
                    ),
                    width: 550,
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ///photo part
                          AspectRatio(
                            aspectRatio: 16/9,
                            child: Container(
                              height: 150,
                              margin: const EdgeInsets.all(5),
                              child: ItemImageHolder(
                                imagePath: imagePath,
                                onSet: (path){
                                  imagePath=path;
                                  setState(() {});
                                },
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          ///select group dropdown list and add group
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: DropListModel(
                                    listItem: wareProvider.itemCategories,
                                    selectedValue:
                                        wareProvider.selectedItemCategory,
                                    onChanged: (val) {
                                      wareProvider
                                          .updateSelectedItemCategory(val);
                                    }),
                              ),
                              Flexible(
                                child: ActionButton(
                                    label: "افزودن گروه",
                                    icon: Icons.add,
                                    onPress: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              CreateItemCategoryPanel());
                                    }),
                              ),
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text("واحد"),
                              const SizedBox(
                                width: 20,
                              ),
                              Flexible(
                                child: DropListModel(
                                  height: 35,
                                  selectedValue: unitItem,
                                  listItem: unitList,
                                  onChanged: (val) {
                                    unitItem = val;
                                    setState(() {});
                                  },
                                ),
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

                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Flexible(
                                      child: Text(
                                        "مواد تشکیل دهنده",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    Flexible(
                                      child: ActionButton(
                                        height: 30,
                                          label:"افزودن ماده جدید",
                                        icon:FontAwesomeIcons.plus,
                                          bgColor: kMainColor,
                                          onPress: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                const AddIngredientPanel()).then((value) {
                                              if (value != null) {
                                                value as RawWare;
                                                bool exitedIngredient=false;
                                                for (var element in ingredients) {
                                                  if(element.wareId==value.wareId){
                                                  element.demand+=value.demand;
                                                  exitedIngredient=true;
                                                }
                                                }
                                                if(!exitedIngredient){
                                                  ingredients.add(value);
                                                }
                                                setState(() {});
                                              }
                                            });
                                          },
                                          ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  decoration: ingredients.isEmpty?null: BoxDecoration(
                                      borderRadius:BorderRadius.circular(15).copyWith(topLeft: const Radius.circular(0)),
                                      border: Border.all(color: kMainColor)),
                                  padding: const EdgeInsets.all(9),
                                  child: Wrap(
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
                                ),
                              ],
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
                                const Flexible(child: Text("قیمت تمام شده :")),
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
                  ),
                );
              }),
            ),
          ),
        ),
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
