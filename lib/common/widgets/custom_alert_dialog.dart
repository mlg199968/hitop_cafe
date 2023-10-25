import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
AlertDialog CustomAlertDialog(
    {required BuildContext context,
    String? title,
    required Widget child,
    double? height,
    double width=450,
    textDirection = TextDirection.rtl,
      double opacity=.75,
    }) {
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    iconPadding: EdgeInsets.zero,
    contentPadding: EdgeInsets.zero,
    backgroundColor: Colors.white.withOpacity(opacity),
    scrollable: true,
    content: BlurryContainer(
        borderRadius: BorderRadius.circular(5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
          Center(
              child:title == null
                  ? null
                  :  Text(
                title,
                style: const TextStyle(color: Colors.black54,fontSize: 18),
              )),
          Directionality(
            textDirection: textDirection,
            child: Flexible(
              child: Container(
                  height:height,// ?? MediaQuery.of(context).size.height,
                  width: width, // ?? MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(20),
                  child: child),
            ),
          ),
        ],
      ),
    ),
  );
}
