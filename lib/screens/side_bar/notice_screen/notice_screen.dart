import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/models/notice.dart';
import 'package:hitop_cafe/screens/side_bar/notice_screen/panels/notice_detail_panel.dart';
import 'package:hitop_cafe/screens/side_bar/notice_screen/services/notice_tools.dart';
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
    // TODO: implement dispose
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
          const Gap(5)
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 120),
          decoration: const BoxDecoration(gradient: kMainGradiant),
          child: SingleChildScrollView(
            child: SizedBox(
              width: 500,
              child: Column(
                children: [
                  ///show loading when refreshing the screen
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutExpo,
                    child:refreshing? Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8,vertical: 20),
                      width: 35,
                      height: 35,
                      child: const CircularProgressIndicator(color: Colors.white60,strokeWidth: 2,),
                    ):const SizedBox() ,),
                  ValueListenableBuilder(
                      valueListenable: HiveBoxes.getNotice().listenable(),
                      builder: (context, box, child) {
                        if(box.isNotEmpty) {
                          return Column(
                              children: box.values
                                  .map(
                                    (notice) => NoticeTile(
                                  notice: notice,
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            NoticeDetailPanel(notice: notice))
                                        .then((value) {
                                      Notice copyNotice = notice.copyWith(seen: true);
                                      HiveBoxes.getNotice()
                                          .put(copyNotice.noticeId, copyNotice);
                                    });
                                  },
                                ),
                              )
                                  .toList()
                                  .reversed
                                  .toList());
                        }
                        else{
                          return const Text("اطلاع رسانی یافت نشد!");
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

class NoticeTile extends StatelessWidget {
  const NoticeTile({
    super.key,
    required this.notice,
    required this.onTap,
  });
  final Notice notice;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: notice.seen ? 0.6 : 1,
      child: Card(
        color: Colors.white,
        elevation: notice.seen ? 0 : 1,
        child: ListTile(
          title: Text(notice.title),
          subtitle: Text(
            notice.content ?? "",
            style: const TextStyle(fontSize: 11),
          ),
          onTap: onTap,
          leading: const Icon(Icons.notifications),
          trailing: Text(
            notice.noticeDate?.toPersianDate() ?? "",
            style: const TextStyle(fontSize: 11, color: Colors.black38),
          ),
        ),
      ),
    );
  }
}
