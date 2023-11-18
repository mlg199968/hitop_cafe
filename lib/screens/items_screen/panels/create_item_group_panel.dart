import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_alert_dialog.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/providers/ware_provider.dart';

import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CreateItemCategoryPanel extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  CreateItemCategoryPanel({super.key});
  TextEditingController groupPanelTextFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'افزودن گروه جدید',
      height: 250,
      child: Consumer<WareProvider>(
        builder: (context,wareProvider,child) {
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
                            CustomTextField(
                              label: "نام گروه",
                              controller: groupPanelTextFieldController,
                              validate: true,
                              maxLength: 20,
                              width: MediaQuery.of(context).size.width,
                              extraValidate: (val){
                                for (var element in wareProvider.itemCategories) {
                                  if (element == groupPanelTextFieldController.text) {
                                    return "نام انتخاب شده تکراری می باشد";
                                  }
                                }
                              },
                            ),
                          ]),
                    ),
                    CustomButton(
                        text: "افزودن",
                        width: MediaQuery.of(context).size.width,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            wareProvider.addItemCategory(groupPanelTextFieldController.text);
                            wareProvider.updateSelectedItemCategory(
                                groupPanelTextFieldController.text);
                            Navigator.pop(context);
                            groupPanelTextFieldController.clear();
                          }
                        })
                  ],
                ),
              ),
            );
        }
      ),

    );
  }
}
