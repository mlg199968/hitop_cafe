import 'dart:io';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/common/widgets/hide_keyboard.dart';
import 'package:hitop_cafe/constants/constants.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    this.title,
    required this.child,
    this.height,
    this.textDirection = TextDirection.rtl,
    this.opacity = .8,
    this.image,
    this.borderRadius=20, this.contentPadding, this.topTrail,
  });
  final String? title;
  final Widget child;
  final Widget? topTrail;
  final double? height;
  final double width = 450;
  final TextDirection textDirection;
  final double opacity;
  final double borderRadius;
  final String? image;
  final EdgeInsets? contentPadding;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      iconPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(opacity),
      scrollable: true,
      content: HideKeyboard(
        child: BlurryContainer(
          blur: 10,
          padding: const EdgeInsets.all(0),
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            children: [
              ///image holder part with faded button,
              Opacity(
                opacity: .7,
                child: Container(
                  width: width,
                  height: 250,
                  decoration: BoxDecoration(
                    image: image == null
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
                            size: 30,
                          ),
                        ),
                      ),

                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(gradient: kMainGradiant),
                      child:CText(
                              title,
                        color: Colors.white,
                        fontSize: 18,
                            )),
                  Directionality(
                    textDirection: textDirection,
                    child: Flexible(
                      child: Container(
                          margin: image == null
                              ? null
                              : const EdgeInsets.all(20).copyWith(top: 50),
                          //decoration for image if image is not null
                          decoration: image == null
                              ? null
                              : BoxDecoration(
                                  gradient: const LinearGradient(
                                      colors: [
                                        Colors.white,
                                        Colors.transparent
                                      ],
                                      stops: [
                                        0,
                                        .8
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                          height:
                              height, // ?? MediaQuery.of(context).size.height,
                          width: width, // ?? MediaQuery.of(context).size.width,
                          padding:contentPadding ?? const EdgeInsets.all(20).copyWith(top: 10),
                          child: child),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
