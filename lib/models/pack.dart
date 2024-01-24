import 'dart:convert';

import 'package:hive/hive.dart';
part 'pack.g.dart';

@HiveType(typeId: 12)
class Pack extends HiveObject {
  @HiveField(0)
  String? type;
  @HiveField(1)
  String? message;
  @HiveField(2)
  String? device;
  @HiveField(3)
  List? object;
  @HiveField(4)
  DateTime date = DateTime.now();
  @HiveField(5)
  String packId = "0";

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'message': message,
      'device': device,
      'object': object,
      'date': date.toIso8601String(),
      'packId': packId,
    };
  }

   Pack fromMap(Map<String, dynamic> map) {
     Pack pack= Pack()
      ..type= map['type']
      ..message= map['message']
      ..device= map['device']
       ..object= map['object']
      ..date= map['date']!=null?DateTime.parse(map['date']):DateTime.now()
      ..packId= map['packId'] ?? "0";
     return pack;
  }
  String toJson()=>jsonEncode(toMap());
  Future<Pack> fromJson(String source)async =>fromMap(await jsonDecode(source));
}

//run this code for create adaptor:
//flutter packages pub run build_runner build --delete-conflicting-outputs
//dart run build_runner build --delete-conflicting-outputs
