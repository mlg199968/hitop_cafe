import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_alert_dialog.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/common/widgets/drop_list_model.dart';
import 'package:hitop_cafe/common/widgets/ware_suggestion_textfield.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/purchase.dart';
import 'package:hitop_cafe/models/raw_ware.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/screens/items_screen/items_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class WareToBillPanel extends StatefulWidget {
  static const String id = "/ware-to-bill-panel";
  const WareToBillPanel({super.key, this.oldItem});
  final RawWare? oldItem;
  @override
  State<WareToBillPanel> createState() => _WareToBillPanelState();
}

class _WareToBillPanelState extends State<WareToBillPanel> {
  final _formKey = GlobalKey<FormState>();
  late final UserProvider userProvider;
  TextEditingController itemNameController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController discountController = TextEditingController();

  String unitItem = unitList[0];
  bool isCheck = false;
  RawWare? selectedItem;
  void replaceOldPurchase(RawWare? old) {
    if (old != null) {
      itemNameController.text = old.wareName;
      salePriceController.text = addSeparator(old.cost);
      quantityController.text = old.quantity.toString();
      unitItem = old.unit;
      isCheck = old.cost < 0 ? true : false;
    }
  }

  void getItemData(RawWare ware) {
    itemNameController.text = ware.wareName;
    salePriceController.text = addSeparator(ware.cost);
    quantityController.text = 1.toString();
    unitItem = ware.unit;
    selectedItem = ware;
    setState(() {});
  }

  @override
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    replaceOldPurchase(widget.oldItem);
    discountController.text = userProvider.preDiscount.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      height: MediaQuery.of(context).size.height * .5,
      title: "افزودن کالا به فاکتور",
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
                        Expanded(
                          flex: 1,
                          child: CustomButton(
                            height: 40,
                            text: "انتخاب",
                            onPressed: () {
                              Navigator.pushNamed(context, ItemsScreen.id,
                                      arguments: const Key(WareToBillPanel.id))
                                  .then((value) {
                                if (value != null) {
                                  value as RawWare;
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
                            child: WareSuggestionTextField(
                              label: "نام کالا",
                              controller: itemNameController,
                              onSuggestionSelected: (RawWare ware) {
                                itemNameController.text = ware.wareName;
                                salePriceController.text =
                                    addSeparator(ware.cost);
                                quantityController.text = 1.toString();
                                unitItem = ware.unit;
                                selectedItem = ware;
                              },
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      enable: false,
                      label: "قیمت خرید",
                      controller: salePriceController,
                      width: MediaQuery.of(context).size.width,
                      textFormat: TextFormatter.price,
                      validate: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextField(
                          label: "مقدار",
                          controller: quantityController,
                          textFormat: TextFormatter.number,
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
                    customDivider(context: context, color: Colors.white70),
                    const SizedBox(height: 5),
                    customDivider(context: context, color: Colors.white70),
                  ],
                ),
              ),
            ),
          ),
          CustomButton(
              width: MediaQuery.of(context).size.width,
              text:
                  widget.oldItem == null ? "افزودن به فاکتور" : "ذخیره تغییرات",
              onPressed: () {
                if (_formKey.currentState!.validate() && selectedItem != null) {
                  double quantity = double.parse(quantityController.text);
                  Purchase purchase = Purchase(
                      wareName: itemNameController.text,
                      unit: unitItem,
                      description: "",
                      price: stringToDouble(salePriceController.text),
                      quantity: quantity,
                      createDate: DateTime.now(),
                      purchaseId: const Uuid().v1(),
                  );

                  Navigator.pop(context, purchase);
                }
              }),
        ],
      ),
    );
  }
}
