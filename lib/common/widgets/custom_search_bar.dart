import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/drop_list_model.dart';
class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar(
      {super.key,
      required this.controller,
      required this.hint,
      required this.onChange(val),
      required this.selectedSort,
      required this.sortList,
      required this.onSort,
        this.iconColor= Colors.white70,
      this.focusNode

      });
  final TextEditingController controller;
  final String hint;
  final Function onChange;
  final String selectedSort;
  final Function onSort;
  final List sortList;
  final FocusNode? focusNode;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: SizedBox(
              width: 400,
              height: 45,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 4,
                child: Center(
                  child: TextField(
                    focusNode: focusNode,
                    controller: controller,
                    onChanged: (val) {
                      onChange(val);
                    },
                    decoration: InputDecoration(

                      //isDense: true,
                      contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: hint,
                      suffixIcon: const Icon(Icons.search_outlined),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder:OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent,strokeAlign: BorderSide.strokeAlignOutside),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent,strokeAlign: BorderSide.strokeAlignOutside),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    cursorHeight: 25,
                  ),
                ),
              ),
            ),
          ),
        ),
        DropListModel(
          icon: Icon(Icons.sort,size: 30,color:iconColor,),
            listItem: sortList,
            selectedValue: selectedSort,
            onChanged: (val) {
              onSort(val);
            })
      ],
    );
  }
}
