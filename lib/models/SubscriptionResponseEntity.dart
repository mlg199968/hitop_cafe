//api post response msg
// class SubscriptionResponseEntity {
//   int? code;
//   String? msg;
//   // CourseItem? data;
//
//   SubscriptionResponseEntity({
//     this.code,
//     this.msg,
//     // this.data,
//   });
//
//   factory SubscriptionResponseEntity.fromJson(Map<String, dynamic> json) =>
//       SubscriptionResponseEntity(
//         code: json["code"],
//         msg: json["msg"],
//         // data: CourseItem.fromJson(json["data"]),
//       );
// }
class SubscriptionResponseEntity {
  bool? success;

  SubscriptionResponseEntity({this.success});

  SubscriptionResponseEntity.fromJson(Map<String, dynamic> json) {
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    return data;
  }
}
