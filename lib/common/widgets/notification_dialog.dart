
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import '../../constants/constants.dart';

class NotificationDialog extends StatelessWidget {
  const NotificationDialog({
    super.key,
    this.title,
    required this.child,
    this.height,
    this.textDirection = TextDirection.rtl,
    this.opacity = .9,
    this.image,
    this.borderRadius = 20,
    this.vip = false,
    this.contentPadding,
    this.topTrail, this.actions,
  });
  final String? title;
  final EdgeInsets? contentPadding;
  final Widget child;
  final Widget? topTrail;
  final double? height;
  final double width = 500;
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
      backgroundColor: Colors.transparent,
      elevation: 20,
      surfaceTintColor: Colors.white,
      scrollable: true,
      insetPadding: EdgeInsets.zero,
      content: GestureDetector(
        onTap: (){Navigator.pop(context);},
        child: BlurryContainer(
          color: Colors.black12,
          borderRadius: BorderRadius.zero,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ///close button
                IconButton.outlined(
                  color: Colors.white,
                    onPressed: (){Navigator.pop(context);},
                    icon: const Icon(Icons.close_rounded),
                ),
                Container(
                  width: width,
                  height: height,
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(borderRadius),
                    boxShadow: const [BoxShadow(color: Colors.black54,blurRadius: 5,offset: Offset(1, 2))]

                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(borderRadius),
                    child: Stack(
                      children: [
                        ///top bar
                        Container(
                          margin: const EdgeInsets.all(10),
                            child: title == null
                                ? null
                                : Text(
                              title!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  shadows: [kShadow]),
                            )),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ///image holder part
                            AspectRatio(
                              aspectRatio: 16/9,
                              child: Container(
                                width: width,
                                height: 250,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(borderRadius)
                                ),
                                child:(image == null || image == "")
                                    ? null
                                    :  Image(image: NetworkImage(image!),fit: BoxFit.fitHeight),
                              ),
                            ),
                            Directionality(
                              textDirection: textDirection,
                              child: Flexible(
                                child: Container(
                                    height: height,
                                    width: width,
                                    padding: contentPadding ??
                                        const EdgeInsets.all(20).copyWith(top: 10),
                                    child: child),
                              ),
                            ),
                            if(actions!=null)
                              Row(children: actions!,),
                            const SizedBox(height: 10,),
                          ],
                        ),
                      ].reversed.toList(),
                    ),
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
