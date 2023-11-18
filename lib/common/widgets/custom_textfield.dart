import 'package:flutter/material.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart'
    as formatter;
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:provider/provider.dart';

enum TextFormatter { price, normal, number }

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    this.label,
    required this.controller,
    this.maxLine = 1,
    this.maxLength = 35,
    this.width = 150,
    this.height = 20,
    this.textFormat = TextFormatter.normal,
    this.onChange,
    this.validate = false,
    this.extraValidate,
    this.enable = true,
    this.focus,
    this.suffixIcon,
    this.obscure = false,
    this.prefixIcon,
    this.symbol,
  }) : super(key: key);

  final String? label;
  final TextEditingController controller;
  final int maxLine;
  final int maxLength;
  final double width;
  final double height;
  final Widget? suffixIcon;
  final IconData? prefixIcon;
  final FocusNode? focus;
  final TextFormatter textFormat;
  // ignore: prefer_typing_uninitialized_variables
  final Function(String val)? onChange;
  // ignore: prefer_typing_uninitialized_variables
  final bool validate;
  final Function(String? val)? extraValidate;
  final String? symbol;
  final bool enable;
  final bool obscure;


  @override
  Widget build(BuildContext context) {
    String currency=Provider.of<UserProvider>(context,listen: false).currency;
    bool isPressed = false;
    return SizedBox(
      width: width,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          obscureText: obscure,
          enabled: enable,
          onChanged: onChange,
          focusNode: focus,
          validator: validate
              ? (val) {
                  if (val == null || val.isEmpty) {
                    return " ضروری !";
                  } else {
                    if (extraValidate != null) {
                      return extraValidate!(val);
                    }
                  }

                  return null;
                }
              : null,
          keyboardType: (textFormat == TextFormatter.number ||
                  textFormat == TextFormatter.price)
              ? const TextInputType.numberWithOptions(decimal: true)
              : null,
          inputFormatters: textFormat == TextFormatter.price
              ? [
                  formatter.CurrencyTextInputFormatter(
                    customPattern: symbol == null ? null : " $symbol ",
                    symbol: "",
                    decimalDigits: 0,
                  )
                ]
              : null,

          onTap: () {
            if (!isPressed) {
              //logic:when user tap on the textfield ,text get selected
              controller.selection = TextSelection(
                  baseOffset: 0, extentOffset: controller.value.text.length);
            }
            isPressed = true;
          },
          textAlign: TextAlign.center,
          maxLines: maxLine,
          maxLength: maxLength,
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
            suffixIcon:suffixIcon,
            isDense: true,
            contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            counterText: "",
            filled: true,
            fillColor: Colors.white,
            hoverColor: Colors.white70,
            label:label==null?null: Text(
              textFormat == TextFormatter.price?
              "${label!} ($currency)":label!,
              style: const TextStyle(color: kMainColor3),
              maxLines: 1,
              overflow: TextOverflow.fade,
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: .5),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: .5, color: kMainColor2),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.blueGrey, width: 1)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red)),
          ),
        ),
      ),
    );
  }
}
