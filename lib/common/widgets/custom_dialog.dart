import 'dart:io';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/hide_keyboard.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/screens/side_bar/sidebar_panel.dart';
class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    this.title,
    required this.child,
    this.height,
    this.textDirection = TextDirection.rtl,
    this.opacity = .9,
    this.image,
    this.borderRadius = 20,
    this.vip =false,
    this.contentPadding,
    this.topTrail, this.actions,
  });
  final String? title;
  final EdgeInsets? contentPadding;
  final Widget child;
  final Widget? topTrail;
  final double? height;
  final double width = 450;
  final TextDirection textDirection;
  final double opacity;
  final double borderRadius;
  final String? image;
  final bool vip;
  final List<Widget>? actions;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius)),
      iconPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(opacity),
      surfaceTintColor: Colors.white,
      scrollable: true,
      buttonPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.all(15),
      actionsPadding: EdgeInsets.zero,
      actions:(actions==null || vip)?null:[
        BlurryContainer(
          borderRadius:BorderRadius.vertical(bottom:Radius.circular(borderRadius),),
          child: Row(
            children: actions!,),
        )
      ],
      content: HideKeyboard(
        child: BlurryContainer(
          padding: const EdgeInsets.all(0),
          borderRadius: BorderRadius.vertical(top:Radius.circular(borderRadius),bottom:Radius.circular(actions==null?borderRadius:0),),
          child: SizedBox(
            width: width,
            height: height,
            child: Stack(
              children: [
                Stack(
                  children: [
                    ///image holder part with faded button,
                    Opacity(
                      opacity: .9,
                      child: Container(
                        width: width,
                        height: 250,
                        decoration: BoxDecoration(
                          image: (image == null || image == "")
                              ? null
                              : DecorationImage(
                            image: FileImage(File(image!)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: width,
                      height: 250,
                      decoration: const BoxDecoration(
                          backgroundBlendMode: BlendMode.dstIn,
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.white, Colors.transparent],
                              stops: [.5, .9])),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ///close button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            topTrail ?? const SizedBox(),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.red,
                                  shadows: [
                                    BoxShadow(
                                        blurRadius: 5,
                                        offset: Offset(.5, .8),
                                        color: Colors.black54)
                                  ],
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: (image == null || image == "")
                                  ? kMainGradiant
                                  : null,
                            ),
                            child: title == null
                                ? null
                                : Text(
                              title!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  shadows: [kShadow]),
                            )),
                        Directionality(
                          textDirection: textDirection,
                          child: Flexible(
                            child: Container(
                                margin: (image == null || image == "")
                                    ? null
                                    : const EdgeInsets.all(0).copyWith(top: 80),
                                //decoration for image if image is not null
                                decoration: (image == null || image == "")
                                    ? null
                                    : BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                height: height,
                                width: width,
                                padding: contentPadding ??
                                    const EdgeInsets.all(20).copyWith(top: 10),
                                child: child),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                ///vip Button show here when user is not vip
                if (vip)
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 70),
                    width: MediaQuery.of(context).size.width,
                    height: height ?? MediaQuery.of(context).size.height * .8,
                    color: Colors.black87.withOpacity(.7),
                    //height: MediaQuery.of(context).size.height,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "برای استفاده از این پنل نسخه پرو برنامه را فعال کنید.",
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        PurchaseButton(),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),

    );
  }
}
