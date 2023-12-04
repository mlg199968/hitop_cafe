import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/models/notice.dart';
import 'package:hitop_cafe/screens/side_bar/notice_screen/panels/notice_detail_panel.dart';
import 'package:hitop_cafe/services/backend_services.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class NoticeScreen extends StatelessWidget {
  static const String id = "/notification-screen";
  const NoticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("اطلاع رسانی ها"),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: const BoxDecoration(gradient: kBlackWhiteGradiant),
          child: FutureBuilder(
            future: BackendServices().readNotice(context, "hitop-cafe"),
            builder: (context, snap) {
              Notice notice1 = Notice()
                ..title = "Title"
                ..content = "this is the test message for this tile"
                ..link = "https://googe.com"
                ..linkTitle = "google";
              print(notice1.toJson());
              if (snap.connectionState == ConnectionState.done &&
                  snap.hasData) {
                if (snap.hasData) {
                  return Column(
                    children: snap.data!.map((notice) => NoticeTile(notice: notice!),).toList()


                  );
                } else {
                  return const Center(child: Text("اطلاع رسانی ای یافت نشد"));
                }
              } else if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return const Center(child: Text("خطا در برقراری ارتباط"));
              }
            },
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
  });

  final Notice notice;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      child: ListTile(
        title: Text(notice.title),
        subtitle: Text(
          notice.content ?? "",
          style: const TextStyle(fontSize: 11),
        ),
        onTap: () {
          print(notice);
          showDialog(
              context: context,
              builder: (context) => NoticeDetailPanel(notice: notice));
        },
        leading: const Icon(Icons.notifications),
        trailing: Text(
          notice.noticeDate?.toPersianDate() ?? "",
          style: const TextStyle(fontSize: 11, color: Colors.black38),
        ),
      ),
    );
  }
}
