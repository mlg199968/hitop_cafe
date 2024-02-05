import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_alert_dialog.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/common/widgets/drop_list_model.dart';
import 'package:hitop_cafe/common/widgets/item_suggestion_textfield.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/screens/items_screen/items_screen.dart';
import 'package:hitop_cafe/screens/items_screen/services/item_tools.dart';
import 'package:provider/provider.dart';

class ItemToBillPanel extends StatefulWidget {
 static const String id="/item-to-bill-panel";
  const ItemToBillPanel({Key? key,this.oldItem}) : super(key: key);
final Item? oldItem;
  @override
  State<ItemToBillPanel> createState() => _WareToBillPanelState();
}

class _WareToBillPanelState extends State<ItemToBillPanel> {
  final _formKey = GlobalKey<FormState>();
 late final UserProvider userProvider;
  TextEditingController itemNameController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String unitItem = unitList[0];
  bool isCheck = false;
 Item? selectedItem;
void replaceOldPurchase(Item? old){
  if(old!=null){
    itemNameController.text=old.itemName;
    salePriceController.text=addSeparator(old.sale);
    quantityController.text=old.quantity.toString();
    discountController.text=old.discount.toString();
    descriptionController.text=old.description;
    unitItem=old.unit;
    isCheck=old.sale<0?true:false;
    selectedItem=old;
    setState(() {});
  }
}
  void getItemData(Item item) {
    itemNameController.text = item.itemName;
    salePriceController.text = addSeparator(item.sale);
    quantityController.text =1.toString();
    unitItem = item.unit;
    selectedItem=item;
    setState(() {});
  }

  @override
  void initState() {
  userProvider=Provider.of<UserProvider>(context,listen: false);
    discountController.text = userProvider.preDiscount.toString();
  replaceOldPurchase(widget.oldItem);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      height: 500,
      title:"افزودن آیتم به فاکتور",
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: SizedBox(
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 1,
                            child: CustomButton(
                              height: 40,
                              text: "انتخاب",
                              onPressed: () {
                                Navigator.pushNamed(
                                        context, ItemsScreen.id,
                                        arguments: const Key(ItemToBillPanel.id))
                                    .then((value) {
                                  if (value != null) {
                                    value as Item;
                                    getItemData(value);
                                  }
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 3,
                            ///ware suggestion textfield part
                            child: ItemSuggestionTextField(
                              label:"نام کالا",
                                controller: itemNameController,
                              onSuggestionSelected:  (Item item){
                                itemNameController.text=item.itemName;
                                salePriceController.text=addSeparator(item.sale);
                                quantityController.text=1.toString();
                                unitItem=item.unit;
                                selectedItem=item;
                              },
                            )
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        enable: false,
                        label: "قیمت فروش",
                        controller: salePriceController,
                        width: MediaQuery.of(context).size.width,
                        textFormat: TextFormatter.price,
                        validate: true,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: CustomTextField(
                              label: "مقدار",
                              controller: quantityController,
                              textFormat: TextFormatter.number,
                            ),
                          ),
                          DropListModel(
                              height: 40,
                              selectedValue: unitItem,
                              listItem: unitList,
                              width: 110,
                              onChanged: (value) {
                                unitItem = value;
                                setState(() {});
                              })
                        ],
                      ),
                      customDivider(
                          context: context, color: Colors.white70),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: "درصد تخفیف",
                              controller: discountController,
                              textFormat: TextFormatter.number,
                              onChange: (val) {
                                if (val != "" &&
                                    stringToDouble(val) > 100) {
                                  discountController.text = 100.toString();
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      customDivider(
                          context: context, color: Colors.white70),
                      CustomTextField(controller: descriptionController,label: "توضیحات",maxLine: 4,maxLength: 250,),
                    ],
                  ),
                ),
              ),
            ),
            CustomButton(
                width: MediaQuery.of(context).size.width,
                text:widget.oldItem==null? "افزودن به فاکتور":"ذخیره تغییرات",
                onPressed: () {

                  if (_formKey.currentState!.validate() && selectedItem!=null ) {
                    num quantity = double.parse(quantityController.text);
                    num discount = discountController.text == ""
                        ? 0
                        : stringToDouble(discountController.text);
                    if(widget.oldItem==null) {
                    selectedItem!
                      ..discount = discount
                      ..quantity = quantity
                    ..description=descriptionController.text;
                    Navigator.pop(
                        context, ItemTools.copyToNewItem(selectedItem!));
                  }else{
                      selectedItem!
                        ..discount = discount
                        ..quantity = quantity
                        ..description=descriptionController.text;
                      Navigator.pop(
                          context,selectedItem!);
                    }
                }
                }),
          ],
        ),
    );
  }
}
