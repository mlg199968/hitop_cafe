import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/counter_textfield.dart';
import 'package:hitop_cafe/common/widgets/custom_alert_dialog.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/ware_suggestion_textfield.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/raw_ware.dart';
import 'package:hitop_cafe/providers/ware_provider.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/raw_ware_screen.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AddIngredientPanel extends StatefulWidget {
  static const String id = "/add-ingredient-panel";

  const AddIngredientPanel({super.key});

  @override
  State<AddIngredientPanel> createState() => _AddIngredientPanelState();
}

class _AddIngredientPanelState extends State<AddIngredientPanel> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController ingredientNameController = TextEditingController();

  TextEditingController demandController = TextEditingController(text: "0");

  RawWare? selectedRawWare;

  void getItemData(ware) {
    //setState(() {});
  }
  @override
  void dispose() {
   ingredientNameController.dispose();
   demandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'افزودن ماده تشکیل دهنده جدید',
      child: Consumer<WareProvider>(builder: (context, wareProvider, child) {
        return Container(
          padding: const EdgeInsetsDirectional.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ///choose material part
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: CustomButton(
                                height: 40,
                                text: "انتخاب",
                                onPressed: () {
                                  Navigator.pushNamed(
                                          context, WareListScreen.id,
                                          arguments:
                                               const Key(AddIngredientPanel.id))
                                      .then((value) {
                                    if (value != null) {
                                      value as RawWare;
                                      ingredientNameController.text =
                                          value.wareName;
                                      selectedRawWare = value;
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
                                  label: "نام کالا خام",
                                  controller: ingredientNameController,
                                  onSuggestionSelected: (RawWare ware) {
                                    ingredientNameController.text =
                                        ware.wareName;
                                    selectedRawWare = ware;
                                    setState(() {});
                                  },
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("مقدار مورد استفاده"),
                        ///demon type ,how much need
                        CounterTextfield(
                          controller: demandController,
                          onChange: (val){

                            setState(() {});
                          },
                          symbol: selectedRawWare != null
                              ? selectedRawWare!.unit
                              : null,
                        ),
                      ]),
                ),
                CustomButton(
                    text: "افزودن",
                    width: MediaQuery.of(context).size.width,
                    onPressed: () {
                      if (_formKey.currentState!.validate() && selectedRawWare!=null) {
                        selectedRawWare!.demand =
                            stringToDouble(demandController.text);
                        Navigator.pop(context, selectedRawWare);
                        ingredientNameController.clear();
                      }else{
                        showSnackBar(context, "مقادیر داده شده ناقص است",type: SnackType.warning);
                      }
                    })
              ],
            ),
          ),
        );
      }),
    );
  }
}
