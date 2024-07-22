
import 'dart:convert';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/plan.dart';
import 'package:hive/hive.dart';

import 'server_models/device.dart';

part 'subscription.g.dart';
@HiveType(typeId: 8)
class Subscription extends HiveObject{

  @HiveField(0)
  String? name;
  @HiveField(1)
  late String phone;
  @HiveField(2)
  String? email;
  @HiveField(3)
  late int level;
  @HiveField(4)
  DateTime? startDate;
  @HiveField(5)
  DateTime? endDate;
  @HiveField(6)
  int? amount;
  @HiveField(7)
  String? authority;
  @HiveField(8)
  String? status;
  @HiveField(9)
  String? refId;
  @HiveField(10)
  Device? device;
  @HiveField(11)
  String? description;
  @HiveField(12)
  int? id;
  @HiveField(13)
  String? platform;
  @HiveField(14)
  String? appName;
  @HiveField(15)
  DateTime? fetchDate;
  @HiveField(16)
  List<Plan>? planList;
  @HiveField(17)
  Plan? plan;

int get userLevel {
  if(endDate == null || (endDate != null && DateTime.now().isAfter(endDate!))){
    return 0;
  } else{
    return level;
  }
}


  Map<String, dynamic> toMap() {
    return {
      'name': name ,
      'phone': phone,
      'email': email,
      'level': level,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'fetch_date': fetchDate?.toIso8601String(),
      'amount': amount,
      'Authority': authority,
      'Status': status,
      'ref_id': refId,
      'device': device?.toMap(),
      'description': description ,
     'id': id,
     'platform': platform,
     'app_name': appName,
     'plan': plan?.toMap(),
     'plans': (planList??[]).map((e) => e.toMap()).toList(),
    };
  }

  Subscription fromMap(Map<String, dynamic> map) {
    List<Plan>? plans =(map['plans']==null || map['plans']=="")?null:
    List<Plan>.from((map['plans']).map((e) => Plan().fromMap(e)));

     Subscription subscription=Subscription()
      ..name= map['name'] ?? ""
      ..phone= map['phone'] ?? ""
      ..email= map['email'] ?? ""
       ..level= int.tryParse(map['level'] ?? "0") ?? 0
      ..startDate= DateTime.tryParse(map['start_date'] ?? "")
      ..endDate= DateTime.tryParse(map['end_date'] ?? "")
      ..fetchDate= DateTime.tryParse(map['fetch_date'] ?? "")
       ..amount= int.tryParse(map['amount'] ?? "0")
      ..authority= map['Authority']
      ..status= map['Status']
      ..refId= map['ref_id']
      ..device=map['device']!=null? Device.fromMap(map['device']):null
      ..description= map['description']
      ..appName= map['app_name']
       ..plan=map["plan"]!=null?Plan().fromMap(map["plan"]):null
       ..planList=plans
       ..id= int.tryParse(map['id'] ?? "");
     return subscription;
  }

  String toJson() => jsonEncode(toMap());

  Subscription fromJson(String source) => fromMap(
    jsonDecode(source),
  );
}

//run this code for create adaptor:
//dart run build_runner build --delete-conflicting-outputs