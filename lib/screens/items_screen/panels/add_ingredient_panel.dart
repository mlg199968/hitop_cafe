import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hitop_cafe/common/widgets/custom_alert_dialog.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/common/widgets/ware_suggestion_textfield.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/raw_ware.dart';
import 'package:hitop_cafe/providers/ware_provider.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/raw_ware_screen.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AddIngredientPanel extends StatelessWidget {
  static const String id="/add-ingredient-panel";
  final _formKey = GlobalKey<FormState>();
  AddIngredientPanel({super.key});
  TextEditingController ingredientNameController = TextEditingController();
  TextEditingController demandController = TextEditingController(text: "0");
  RawWare? selectedRawWare;
  void getItemData(ware) {
    //setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      context: context,
      title: 'افزودن ماده تشکیل دهنده جدید',
      height: 300,
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
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                                          arguments: const Key(AddIngredientPanel.id))
                                      .then((value) {
                                    if (value != null) {
                                      value as RawWare;
                                      ingredientNameController.text =
                                          value.wareName;
                                      selectedRawWare=value;
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
                                    selectedRawWare=ware;
                                  },
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        ///demon type ,how much need
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                 double num1=stringToDouble(demandController.text==""?"0":demandController.text);
                                  demandController.text =
                                      ( num1+ 1)
                                          .toString();
                                },
                                icon: const Icon(FontAwesomeIcons.plus)),
                            Flexible(
                              child: CustomTextField(
                                label: "مقدار مورد استفاده",
                                controller: demandController,
                                symbol: selectedRawWare!=null?selectedRawWare!.unit:null,
                                textFormat: TextFormatter.number,
                                onChange: (val) {
                                  if (val != "" &&
                                      stringToDouble(val) < 0 ) {
                                    demandController.text = 0.toString();
                                  }
                                },
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  demandController.text =
                                      (stringToDouble(demandController.text) - 1)
                                          .toString();
                                },
                                icon: const Icon(FontAwesomeIcons.minus)),
                          ],
                        ),
                      ]),
                ),
                CustomButton(
                    text: "افزودن",
                    width: MediaQuery.of(context).size.width,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        selectedRawWare!.demand=stringToDouble(demandController.text);
                        Navigator.pop(context,selectedRawWare);
                        ingredientNameController.clear();
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
