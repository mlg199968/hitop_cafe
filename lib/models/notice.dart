import 'dart:convert';

import 'package:hive/hive.dart';
part 'notice.g.dart';

@HiveType(typeId: 9)
class Notice extends HiveObject {
  @HiveField(0)
  String title = "";
  @HiveField(1)
  String? content;
  @HiveField(2)
  String? link;
  @HiveField(3)
  String? linkTitle;
  @HiveField(4)
  String? image;
  @HiveField(5)
  DateTime? noticeDate=DateTime.now();
  @HiveField(6)
  bool seen = false;
   @HiveField(7)
  bool important = false;
  @HiveField(8)
  String noticeId = "";

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'link': link,
      'linkTitle': linkTitle,
      'image': image,
      'seen': seen ? 1 : 0,
      'important': important ? 1 : 0,
      'noticeDate': noticeDate?.toIso8601String(),
      'noticeId': noticeId,
    };
  }

  Notice fromMap(Map<String, dynamic> map) {
    Notice notice = Notice()
      ..title = map['title'] ?? ""
      ..content = map['content'] ?? ""
      ..link = map['link'] ?? ""
      ..linkTitle = map['linkTitle'] ?? ""
      ..image = map['image'] ?? ""
      ..seen = map['seen'] == 1 ? true : false
      ..important = map['important'] == 1 ? true : false
      ..noticeDate =DateTime.parse(map['noticeDate'] ?? DateTime.now().toIso8601String())
      ..noticeId = map['noticeId'] ?? "0";
    return notice;
  }

  String toJson() => jsonEncode(toMap());
  Notice fromJson(String source) => fromMap(jsonDecode(source));

  Notice copyWith({
    String? title,
    String? content,
    String? link,
    String? linkTitle,
    String? image,
    DateTime? noticeDate,
    bool? seen,
    bool? important,
    String? noticeId,
    Notice? notice,
  }) {
    Notice copyNotice=Notice()
      ..title= title ?? this.title
      ..content= content ?? this.content
      ..link= link ?? this.link
      ..linkTitle= linkTitle ?? this.linkTitle
      ..image= image ?? this.image
      ..noticeDate= noticeDate ?? this.noticeDate
      ..seen= seen ?? this.seen
      ..important= important ?? this.important
      ..noticeId= noticeId ?? this.noticeId;

    return copyNotice;
  }
}


//run this code for create adaptor:
//flutter packages pub run build_runner build --delete-conflicting-outputs
