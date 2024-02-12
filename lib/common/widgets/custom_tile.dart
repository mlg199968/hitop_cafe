import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hitop_cafe/common/shape/background_shape1.dart';
import '../../../constants/constants.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CustomTile extends StatelessWidget {
  const CustomTile(
      {super.key,
      required this.onDelete,
      required this.height,
      required this.color,
      this.subTitle,
      required this.title,
      required this.topTrailing,
      required this.trailing,
      this.leadingIcon,
      this.topTrailingLabel,
      this.onInfo,
      this.type,
      this.enable = true, this.selected=false});
  final VoidCallback onDelete;
  final double height;
  final Color color;
  final String? subTitle;
  final String title;
  final String topTrailing;
  final String? topTrailingLabel;
  final String trailing;
  final String? type;
  final IconData? leadingIcon;
  final VoidCallback? onInfo;
  final bool enable;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Slidable(
        key: UniqueKey(),
        enabled: enable,
        useTextDirection: false,
        endActionPane: onInfo == null
            ? ActionPane(
                extentRatio: .2,
                motion: const DrawerMotion(),
                dragDismissible: true,
                dismissible: DismissiblePane(
                  onDismissed: () => onDelete(),
                ),
                children: [
                  SlidableAction(
                    label: "حذف",
                    onPressed: (context) => {onDelete()},
                    icon: FontAwesomeIcons.trashCan,
                    backgroundColor: Colors.red,
                  ),
                ],
              )
            : ActionPane(
                extentRatio: .4,
                motion: const DrawerMotion(),
                dragDismissible: true,
                dismissible: DismissiblePane(
                  onDismissed: () => onDelete(),
                ),
                children: [
                  SlidableAction(
                    label: "جزئیات",
                    borderRadius:const BorderRadius.horizontal(left: Radius.circular(10)),
                    onPressed: (context) => {onInfo!()},
                    icon: FontAwesomeIcons.pencil,
                    backgroundColor: Colors.blueAccent,
                  ),
                  SlidableAction(
                    label: "حذف",

                    borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
                    onPressed: (context) => {onDelete()},
                    icon: FontAwesomeIcons.trashCan,
                    backgroundColor: Colors.red,
                  ),
                ],
              ),
        child: Builder(builder: (context) {
          return SizedBox(
            width: 450,
            child: Card(
             surfaceTintColor: Colors.white,
              margin: selected ?const EdgeInsets.only(right: 20):null,
              child: BackgroundShape1(
                color: color,
                height: height,
                child: MyListTile(
                    enable: enable,
                    selected: selected,
                    title: title,
                    leadingIcon: leadingIcon,
                    type: type,
                    subTitle: subTitle,
                    topTrailingLabel: topTrailingLabel,
                    topTrailing: topTrailing,
                    trailing: trailing),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class MyListTile extends StatelessWidget {
   MyListTile({
    super.key,
    required this.enable,
    required this.title,
    this.leadingIcon,
    this.type,
    this.subTitle,
    this.topTrailingLabel,
    required this.topTrailing,
    required this.trailing, this.selected=false,
  });

  final bool enable;
  final bool selected;
  final String title;
  final IconData? leadingIcon;
  final String? type;
  final String? subTitle;
  final String? topTrailingLabel;
  final String topTrailing;
  final String trailing;
  final tileGlobalKey=GlobalKey();
  @override
  Widget build(BuildContext context) {
    //TODO: order tile responsive added
    return LayoutBuilder(
      builder: (context,constraint){
      return ListTile(
        selected: selected,
        onTap: !enable
            ? null
            : () {
                final slidable = Slidable.of(context)!;
                final isClosed =
                    slidable.actionPaneType.value == ActionPaneType.none;
                if (isClosed) {
                  slidable.openEndActionPane(
                      duration: const Duration(milliseconds: 600));
                } else {
                  slidable.close();
                }
              },
        iconColor: Colors.black26,
        contentPadding: const EdgeInsets.symmetric(horizontal: 5),
        dense: true,
        title: Text(
          title,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
          maxLines: 2,
        ),
        leading: leadingIcon == null || constraint.maxWidth<200
            ? null:SizedBox(
                child: Column(
                  children: [
                    Expanded(
                        child: Icon(
                      leadingIcon,
                      size: 20,
                    )),
                    Text(
                      type ?? "",
                      style: TextStyle(
                          fontSize: 12,
                          color: selected ? Colors.blue : Colors.black38),
                    ),
                    const SizedBox(
                      height: 5,
                    )
                  ],
                ),
              )
            ,
        subtitle: Text(subTitle ?? "",style: const TextStyle(fontSize: 11,color: Colors.black45),),
        trailing: constraint.maxWidth < 300
            ? null
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(
                      text: topTrailingLabel ?? "",
                      style: TextStyle(
                          color: selected ? Colors.blue : Colors.black54,
                          fontSize: 11),
                      children: [
                        TextSpan(
                            text: topTrailing,
                            style: TextStyle(
                                color: selected ? Colors.blue : Colors.black54,
                                fontSize: 11,
                                fontFamily: kCustomFont)),
                      ],
                    ),
                  ),
                  AutoSizeText(
                    trailing,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    textDirection: TextDirection.ltr,
                    maxLines: 2,
                   // style: kCellStyle,
                    minFontSize: 9,
                    maxFontSize: 12,
                  ),
                ],
              ),
      );
    });
  }
}


