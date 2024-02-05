import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';


class ItemSuggestionTextField extends StatelessWidget {
  const ItemSuggestionTextField(
      {super.key,
      required this.label,
      required this.controller,
      this.maxLine = 1,
      this.maxLength = 35,
      this.width = 150,
      this.height = 20,
      this.textFormat = TextFormatter.normal,
      this.onChange,
      this.validate = false,
      this.enable = true,
      required this.onSuggestionSelected});

  final String label;
  final TextEditingController controller;
  final int maxLine;
  final int maxLength;
  final double width;
  final double height;
  final TextFormatter textFormat;

  // ignore: prefer_typing_uninitialized_variables
  final Function(String val)? onChange;
  final Function(Item val) onSuggestionSelected;

  // ignore: prefer_typing_uninitialized_variables
  final bool validate;
  final bool enable;

  Future<List<Item>> suggestion(String query) async {
    return HiveBoxes.getItem().values.map((e) => e).where((element) {
      String wareName = element.itemName.toLowerCase().replaceAll(" ", "");
      //String serial=element.serialNumber.toLowerCase().replaceAll(" ", "");
      String key = query.toLowerCase().replaceAll(" ", "");
      if (wareName.contains(key)) {
        return true;
      } else {
        return false;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    bool isPressed = false;
    return SizedBox(
      width: width,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TypeAheadField<Item>(
          textFieldConfiguration: TextFieldConfiguration(
            onTap: () {
              if (!isPressed) {
                controller.selection = TextSelection(
                    baseOffset: 0, extentOffset: controller.value.text.length);
              }
              isPressed = true;
            },
            controller: controller,
            maxLength: maxLength,
            maxLines: maxLine,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              counterText: "",
              filled: true,
              fillColor: Colors.white,
              hoverColor: Colors.white70,
              label: AutoSizeText(
                label,
                style: const TextStyle(color: Colors.blueGrey),
                maxFontSize: 14,
                minFontSize: 10,
                maxLines: 1,
                overflow: TextOverflow.fade,
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(width: .5),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: .5, color: kMainColor),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide:
                      const BorderSide(color: kMainColor2, width: 1)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.red)),
            ),
          ),
          suggestionsCallback: suggestion,
          itemBuilder: (context, suggestion) {
            return Container(
              padding: const EdgeInsets.fromLTRB(5, 5, 10, 10),
                child: Text(
              suggestion.itemName,
              textDirection: TextDirection.rtl,
            ));
          },
          onSuggestionSelected: onSuggestionSelected,
          suggestionsBoxDecoration:  const SuggestionsBoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20),)
          ),
        ),
      ),
    );
  }
}
