

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
customAlert(
    {required BuildContext context,
    VoidCallback? onYes,
    VoidCallback? onNo, Widget? extraContent,
    required String title,}) async => await showDialog(
    context: context,
    builder: (context) =>AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      iconPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.5),
      scrollable: true,
      content: BlurryContainer(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ///close icon button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 30,
                ),
              ),
            ),
            ///title part
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                    title,
                    style: const TextStyle(color: Colors.black87,fontSize: 18,),
                textDirection: TextDirection.rtl,
                  ),
            ),
            /// extra widget if need something extra
            SizedBox(
              child: extraContent,
            ),
            ///yes and no buttons part
            Directionality(
              textDirection: TextDirection.rtl,
              child: Flexible(
                child: Container(
                   height:70,// ?? MediaQuery.of(context).size.height,
                    width: 300, // ?? MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                      CustomButton(
                        width: 70,
                        color: Colors.indigo,
                        onPressed: onYes,
                        text: 'بله',
                      ),
                      const SizedBox(width: 20,),
                      CustomButton(
                        color: Colors.redAccent,
                        width: 70,
                        onPressed: onNo, // this line dismisses the dialog
                        text: 'خیر',
                      )
                    ],)),
              ),
            ),
          ],
        ),
      ),
    ),
  );


class CustomAlert extends StatelessWidget {
  const CustomAlert({super.key,
    this.onYes,
    this.onNo,
    this.extraContent,
    required this.title,});
 final String title;
 final VoidCallback? onYes;
 final VoidCallback? onNo;
 final Widget? extraContent;


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      iconPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.black,
      scrollable: true,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ///close icon button
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                CupertinoIcons.multiply_square_fill,
                color: Colors.red,
                size: 30,
                  shadows: [BoxShadow(blurRadius: 1,offset:Offset(.5, .8),color: Colors.black54)],
              ),
            ),
          ),
          ///title part
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              title,
              style: const TextStyle(color: Colors.black87,fontSize: 15,),
              textDirection: TextDirection.rtl,
            ),
          ),
          /// extra widget if need something extra
          SizedBox(
            child: extraContent,
          ),
          ///yes and no buttons part
          Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(8),
              height: 70,
                width: 300,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ActionButton(
                      bgColor: Colors.black87,
                      borderRadius: 5,
                      icon: Icons.done,
                      iconColor: Colors.teal,
                      onPress: onYes,
                      label: 'بله',
                    ),
                    const SizedBox(width: 5,),
                    ActionButton(
                      bgColor: Colors.black87,
                      icon: Icons.close,
                      iconColor: Colors.red,
                      borderRadius: 5,
                      onPress: onNo ?? (){Navigator.pop(context,false);}, // this line dismisses the dialog
                      label: 'خیر',
                    )
                  ],)),
          ),
        ],
      ),
    );
  }
}
