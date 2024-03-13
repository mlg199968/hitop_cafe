import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/utils.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key,
      required this.title,
      this.widgets,
      this.leadingWidth = 120,
      this.height = 60,
      this.actions,
      required this.context2});
  final String title;
  final BuildContext context2;
  final List<Widget>? widgets;
  final List<Widget>? actions;
  final double leadingWidth;
  final double height;

  @override
  Size get preferredSize => Size.fromHeight(
        screenType(context2) == ScreenType.desktop ? height : 130,
      );
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          title,
          style: const TextStyle(fontSize: 20),
        ),
        flexibleSpace: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: 130,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
                .copyWith(left: constraint.maxHeight > 60 ? 10 : leadingWidth,top: Platform.isAndroid || Platform.isIOS?30:5),
            decoration: BoxDecoration(
              borderRadius: screenType(context) != ScreenType.desktop?null: BorderRadius.circular(20),
              gradient: kMainGradiant,
              boxShadow: const [BoxShadow(blurRadius: 5,offset: Offset(2, 3),color: Colors.black54)]
            ),
            child: Wrap(
              spacing: 5,
              runSpacing: 5,
              direction: Axis.horizontal,
              crossAxisAlignment: WrapCrossAlignment.center,
              runAlignment: WrapAlignment.end,
              alignment: WrapAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions ?? [],
                ),
                ...widgets ?? []
              ],
            ),
          ),
        ),
      );
    });
  }
}
