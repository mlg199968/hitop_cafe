import 'dart:convert';

import 'package:hive/hive.dart';


part 'note.g.dart';

@HiveType(typeId: 14)
class Note extends HiveObject {
  @HiveField(0)
  late String title;
  @HiveField(1)
  late String subTitle;
  @HiveField(2)
  late DateTime deadline;
  @HiveField(3)
  late DateTime registrationDate;
  @HiveField(4)
  late String? noteId;
  @HiveField(5)
  bool isDone=false;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subTitle': subTitle,
      'deadline': deadline.toIso8601String(),
      'registrationDate': registrationDate.toIso8601String(),
      'noteId': noteId,
      'isDone': isDone ?1:0,
    };
  }

  Note fromMap(Map<String, dynamic> map) {
     Note noteHive=Note()
      ..title= map['title'] ?? ""
      ..subTitle= map['subTitle'] ?? ""
      ..deadline= DateTime.parse(map['deadline'] ?? "2000-03-18T22:01:05.238")
      ..registrationDate= DateTime.parse(map['registrationDate'] ?? "2000-03-18T22:01:05.238")
      ..noteId= map['noteId'] ?? ""
       ..isDone= map['isDone']==1?true:false;
     return noteHive;
  }
  String toJson() => jsonEncode(toMap());
  Note fromJson(String source) => fromMap(jsonDecode(source));
}


//run this code for create adaptor:
//flutter packages pub run build_runner build --delete-conflicting-outputs