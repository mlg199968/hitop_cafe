

import 'package:hive/hive.dart';

part 'bug.g.dart';
@HiveType(typeId: 10)
class Bug extends HiveObject{
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? errorText;
  @HiveField(2)
  int count=1;
  @HiveField(3)
  String? directory;
  @HiveField(4)
  late DateTime bugDate;
  @HiveField(5)
  late String bugId;
  @HiveField(6)
  String? stacktrace;


}

//run this code for create adaptor:
//flutter packages pub run build_runner build --delete-conflicting-outputs
//dart run build_runner build --delete-conflicting-outputs