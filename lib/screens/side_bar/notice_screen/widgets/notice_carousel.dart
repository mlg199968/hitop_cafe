
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/screens/side_bar/notice_screen/widgets/notice_tile.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../constants/utils.dart';
import '../../../../models/notice.dart';
import '../notice_screen.dart';

class NoticeCarousel extends StatelessWidget {
  const NoticeCarousel({super.key,this.width=600});
  final double width;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child:  LayoutBuilder(builder: (context, constraint) {
          double maxWidth = constraint.maxWidth;
            return Container(
              width: width,
              child: ValueListenableBuilder(
                valueListenable: HiveBoxes.getNotice().listenable(),
                builder: (context,box,child) {
                  List<Notice> noticeList=box.values.toList();
                  return ClipRRect(
                    borderRadius: (maxWidth < width &&
                        screenType(context) == ScreenType.mobile)
                        ? BorderRadius.circular(0)
                        : const BorderRadius.horizontal(
                        left: Radius.circular(15)),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        reverse: false,
                        padEnds: true,
                        enlargeStrategy:
                        CenterPageEnlargeStrategy.zoom,
                        enlargeFactor: 0,
                        enlargeCenterPage: true,
                        autoPlayInterval:
                        const Duration(seconds: 3),
                        autoPlay: true,
                        height: 80,),
                      items: noticeList.map((notice) => NoticeTile(notice: notice, onTap: (){Navigator.pushNamed(
                             context, NoticeScreen.id);})).toList(),
                    ),
                  );
                }
              ),
            );
          }
        ),
      ),
    );
  }
}
