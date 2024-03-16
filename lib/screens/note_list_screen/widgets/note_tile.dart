import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/constants.dart';

class ToDoTile extends StatelessWidget {
  const ToDoTile(
      {super.key,
      required this.title,
      required this.subTitle,
      this.checkValue = false,
      required this.onChanged,
      this.onTap});

  final String title;
  final String subTitle;
  final bool checkValue;
  final Function(bool? val) onChanged;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: checkValue ? Colors.black38 : kSecondaryColor,width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      surfaceTintColor: Colors.white,
      elevation: checkValue ? 0 : 7,
      child: ListTile(
        onTap: onTap,
        enabled: !checkValue,
        title: Text(
          title,
          style: const TextStyle(fontSize: 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          subTitle,
          style: const TextStyle(fontSize: 11, color: Colors.black54),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        leading: Checkbox(
            value: checkValue
            , onChanged: onChanged,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }
}
