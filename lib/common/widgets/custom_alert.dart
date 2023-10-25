
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
Future<bool> customAlert(
    {required BuildContext context,
    VoidCallback? onYes,
    VoidCallback? onNo,
    required String title}) async {
  return await showDialog(
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                    title,
                    style: const TextStyle(color: Colors.black87,fontSize: 18,),
                textDirection: TextDirection.rtl,
                  ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Flexible(
                child: Container(
                   height:70,// ?? MediaQuery.of(context).size.height,
                    width: 300, // ?? MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                      CustomButton(
                        width: 70,
                        color: Colors.blue,
                        onPressed: onYes,
                        text: 'بله',
                      ),
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
}
