import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/constants.dart';

// ignore: must_be_immutable
class DropListModel extends StatelessWidget {
  const DropListModel({
    super.key,
    required this.listItem,
    required this.selectedValue,
    required this.onChanged,
    this.width=140,
    this.height=40,
    this.icon,
    this.elevation=2
  });

  final List listItem;
  final String selectedValue;
  final Function onChanged;
  final double width;
  final double height;
  final Icon? icon;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:icon==null?TextDirection.rtl : TextDirection.ltr,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)),
        color: Colors.transparent,
        elevation: icon==null?elevation:0,
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            iconDisabledColor: Colors.black26,
            iconEnabledColor: kMainColor,
            icon: const Icon(Icons.keyboard_arrow_down),
            iconOnClick: const Icon(Icons.keyboard_arrow_up),

            isExpanded: true,
            itemPadding: const EdgeInsets.all(0),

            customButton:icon,
            isDense: true,
            dropdownWidth: width,
            alignment: Alignment.centerRight,
            scrollbarRadius: const Radius.circular(20),
            dropdownDecoration:BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              //border: Border.all(color: kColorController)
            ),
            buttonDecoration: BoxDecoration(
                color:icon!=null?null:Colors.white,
                borderRadius: BorderRadius.circular(200),
                //border: Border.all(color: kColorController)
            ),
            hint: const Text(
              'no Group',
              style: TextStyle(fontSize: 20, color: Colors.black38),
            ),
            items: listItem
                .map((item) => DropdownMenuItem<String>(
              alignment: Alignment.centerRight,
                      value: item,
                      child: Container(
                        alignment: Alignment.centerRight,
                        color:icon!=null?(selectedValue==item?kMainColor:null):null,
                        padding: const EdgeInsets.only(right: 5),
                        width: width *.7,
                        child: Text(
                          item,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                    ))
                .toList(),
            value: selectedValue,
            onChanged: (val) {
              onChanged(val);
            },


            buttonHeight: height,
            buttonWidth: width,
            itemHeight: height,
          ),
        ),
      ),
    );
  }
}
