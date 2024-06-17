import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/common/widgets/empty_holder.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/models/notice.dart';
import 'package:hitop_cafe/screens/side_bar/notice_screen/panels/notice_detail_panel.dart';
import 'package:hitop_cafe/screens/side_bar/notice_screen/services/notice_tools.dart';
import 'package:hitop_cafe/screens/side_bar/notice_screen/widgets/notice_tile.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class NoticeScreen extends StatefulWidget {
  static const String id = "/notification-screen";
  const NoticeScreen({super.key});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  bool refreshing = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("اطلاع رسانی ها"),
        actions: [
          ActionButton(
            label: "تازه سازی",
            bgColor: Colors.teal,
            icon: Icons.refresh_rounded,
            onPress: () async {
              refreshing = true;
              setState(() {});
              await NoticeTools.readNotifications(context);
              refreshing = false;
              setState(() {});
            },
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 120),
          decoration: const BoxDecoration(gradient: kMainGradiant),
          child: SingleChildScrollView(
            child: Container(
              width: 500,
              height: 800,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: kBlackWhiteGradiant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  ///show loading when refreshing the screen
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutExpo,
                    child: refreshing
                        ? Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 20),
                            width: 35,
                            height: 35,
                            child: const CircularProgressIndicator(
                              color: Colors.white60,
                              strokeWidth: 2,
                            ),
                          )
                        : const SizedBox(),
                  ),
                  ValueListenableBuilder(
                      valueListenable: HiveBoxes.getNotice().listenable(),
                      builder: (context, box, child) {
                        if (box.isNotEmpty) {
                          return Column(
                              children: box.values
                                  .map(
                                    (notice) => NoticeTile(
                                      notice: notice,
                                      onTap: () {
                                        showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    NoticeDetailPanel(
                                                        notice: notice))
                                            .then((value) {
                                          Notice copyNotice =
                                              notice.copyWith(seen: true);
                                          HiveBoxes.getNotice().put(
                                              copyNotice.noticeId, copyNotice);
                                        });
                                      },
                                    ),
                                  )
                                  .toList()
                                  .reversed
                                  .toList());
                        } else {
                          return const EmptyHolder(
                            text: "اطلاع رسانی یافت نشد!",
                            fontSize: 14,
                            iconSize: 50,
                            icon: Icons.notifications_paused,
                            color: Colors.white70,
                          );
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


