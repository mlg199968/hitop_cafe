import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/common/widgets/drop_list_model.dart';
import 'package:hitop_cafe/common/widgets/hide_keyboard.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/raw_ware.dart';
import 'package:hitop_cafe/providers/ware_provider.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/panels/create_group_panel.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/widgets/action_button.dart';
import 'package:hitop_cafe/screens/user_screen/services/user_tools.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddWareScreen extends StatefulWidget {
  static const String id = "/add-ware-screen";
  const AddWareScreen({Key? key, this.oldRawWare}) : super(key: key);
  final RawWare? oldRawWare;

  @override
  State<AddWareScreen> createState() => _AddWareScreenState();
}

class _AddWareScreenState extends State<AddWareScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController wareNameController = TextEditingController();
  FocusNode wareNameFocus = FocusNode();
  TextEditingController costPriceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String unitItem = unitList[0];

  ///save ware on local storage
  void saveWare({String? id}) {
    RawWare rawWare = RawWare(
      wareName: wareNameController.text,
      unit: unitItem,
      category: Provider.of<WareProvider>(context, listen: false)
          .selectedRawWareCategory,
      cost: costPriceController.text.isEmpty
          ? 0
          : stringToDouble(costPriceController.text),
      quantity: quantityController.text.isEmpty
          ? 1000
          : stringToDouble(quantityController.text),
      description:
          descriptionController.text.isEmpty ? "" : descriptionController.text,
      wareId: id ?? const Uuid().v1(),
      createDate: id != null ? widget.oldRawWare!.createDate : DateTime.now(),
      modifiedDate: DateTime.now(),
    );
    // Debuger.maxWare(RawWare, 100);
    HiveBoxes.getRawWare().put(rawWare.wareId, rawWare);
  }
  void restoreOldRawWare(){
    wareNameController.text = widget.oldRawWare!.wareName;
    costPriceController.text = addSeparator(widget.oldRawWare!.cost);
    quantityController.text = widget.oldRawWare!.quantity.toString();
    descriptionController.text = widget.oldRawWare!.description;
    Provider.of<WareProvider>(context, listen: false).selectedRawWareCategory=widget.oldRawWare!.category;
    unitItem=widget.oldRawWare!.unit;
  }
  @override
  void initState() {
    Provider.of<WareProvider>(context,listen: false).loadCategories();
    wareNameFocus.requestFocus();
    if(widget.oldRawWare!=null){
      restoreOldRawWare();
    }
    super.initState();

  }
  @override
  void dispose() {
    wareNameController.dispose();
    costPriceController.dispose();
    quantityController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyboard(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: kMainGradiant),
          ),
          title: Text(widget.oldRawWare == null ? "افزودن کالا" : "اصلاح کالا"),
        ),
        body: Consumer<WareProvider>(builder: (context, wareProvider, child) {
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
                          const SizedBox(
                            height: 20,
                          ),
                          ///select group dropdown list and add group
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: ActionButton(
                                    label: "افزودن گروه",
                                    icon: Icons.add,
                                    onPress: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => CreateGroupPanel());
                                    }),
                              ),
                              Flexible(
                                child: DropListModel(
                                    listItem: wareProvider.rawWareCategories,
                                    selectedValue:
                                        wareProvider.selectedRawWareCategory,
                                    onChanged: (val) {
                                      wareProvider.updateSelectedRawCategory(val);
                                    }),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            label: "نام کالا",
                            controller: wareNameController,
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
                              Flexible(
                                child: DropListModel(
                                  height: 35,
                                  width: 100,
                                  selectedValue: unitItem,
                                  listItem: unitList,
                                  onChanged: (val) {
                                    unitItem = val;
                                    setState(() {});
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Flexible(
                                child: CustomTextField(
                                  label: "مقدار",
                                  controller: quantityController,
                                  textFormat: TextFormatter.number,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            label: "قیمت خرید",
                            controller: costPriceController,
                            textFormat: TextFormatter.price,
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
                        text: widget.oldRawWare == null
                            ? "افزودن به لیست"
                            : "ذخیره تغییرات",
                        width: MediaQuery.of(context).size.width,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (widget.oldRawWare != null) {
                              saveWare(id: widget.oldRawWare!.wareId);
                              Navigator.pop(context, false);
                            } else {
                              ///condition for demo mode
                              if (UserTools.userPermission(context,count: HiveBoxes.getRawWare().values.length,)) {
                                saveWare();
                                showSnackBar(context, "کالا به لیست افزوده شد!",
                                    type: SnackType.success);
                                wareNameController.clear();
                                costPriceController.clear();
                                descriptionController.clear();
                                quantityController.clear();
                                FocusScope.of(context)
                                    .requestFocus(wareNameFocus);
                                setState(() {});
                                // Navigator.pop(context,false);
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
