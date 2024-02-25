class DatalistModel {
  bool? success;
  SubsData? subsData;
  // String? message;
  DatalistModel({this.success, this.subsData});

  DatalistModel.fromJson(Map<String, dynamic>? json) {
    if (json?["success"] is bool) {
      success = json?["success"];
    }
    if (json?["subsData"] is Map) {
      subsData = json?["subsData"] == null
          ? null
          : SubsData.fromJson(json?["subsData"]);
    }
    // if (json?["message"] is String) {
    //   message = json?["message"];
    // }
  }

  static List<DatalistModel?> fromList(List<Map<String, dynamic>> list) {
    return list.map((map) => DatalistModel.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["success"] = success;
    // _data["message"] = message;
    if (subsData != null) {
      _data["subsData"] = subsData?.toJson();
    }
    return _data;
  }

  DatalistModel copyWith({
    bool? success,
    SubsData? subsData,
    // String? message,
  }) =>
      DatalistModel(
        success: success ?? this.success,
        subsData: subsData ?? this.subsData,
        // message: message ?? this.message,
      );
}

class SubsData {
  int? userId;
  int? level;
  String? email;
  String? phone;
  String? name;
  String? description;
  int? refId;
  String? startDate;
  String? endDate;
  int? amount;
  String? authority;
  String? status;
  String? deviceId;
  String? platform;

  SubsData(
      {this.userId,
      this.level,
      this.email,
      this.phone,
      this.name,
      this.description,
      this.refId,
      this.startDate,
      this.endDate,
      this.amount,
      this.authority,
      this.status,
      this.deviceId,
      this.platform});

  SubsData.fromJson(Map<String, dynamic> json) {
    if (json["user_id"] is num) {
      userId = (json["user_id"] as num).toInt();
    }
    if (json["level"] is num) {
      level = (json["level"] as num).toInt();
    }
    if (json["email"] is String) {
      email = json["email"];
    }
    if (json["phone"] is String) {
      phone = json["phone"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["description"] is String) {
      description = json["description"];
    }
    if (json["ref_id"] is num) {
      refId = (json["ref_id"] as num).toInt();
    }
    if (json["start_date"] is String) {
      startDate = json["start_date"];
    }
    if (json["end_date"] is String) {
      endDate = json["end_date"];
    }
    if (json["amount"] is num) {
      amount = (json["amount"] as num).toInt();
    }
    if (json["Authority"] is String) {
      authority = json["Authority"];
    }
    if (json["Status"] is String) {
      status = json["Status"];
    }
    if (json["device_id"] is String) {
      deviceId = json["device_id"];
    }
    if (json["platform"] is String) {
      platform = json["platform"];
    }
  }

  static List<SubsData> fromList(List<Map<String, dynamic>> list) {
    return list.map((map) => SubsData.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["user_id"] = userId;
    _data["level"] = level;
    _data["email"] = email;
    _data["phone"] = phone;
    _data["name"] = name;
    _data["description"] = description;
    _data["ref_id"] = refId;
    _data["start_date"] = startDate;
    _data["end_date"] = endDate;
    _data["amount"] = amount;
    _data["Authority"] = authority;
    _data["Status"] = status;
    _data["device_id"] = deviceId;
    _data["platform"] = platform;
    return _data;
  }

  SubsData copyWith({
    int? userId,
    int? level,
    String? email,
    String? phone,
    String? name,
    String? description,
    int? refId,
    String? startDate,
    String? endDate,
    int? amount,
    String? authority,
    String? status,
    String? deviceId,
    String? platform,
  }) =>
      SubsData(
        userId: userId ?? this.userId,
        level: level ?? this.level,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        name: name ?? this.name,
        description: description ?? this.description,
        refId: refId ?? this.refId,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        amount: amount ?? this.amount,
        authority: authority ?? this.authority,
        status: status ?? this.status,
        deviceId: deviceId ?? this.deviceId,
        platform: platform ?? this.platform,
      );
}

class ErrorResponse {
  final bool? success;
  final String? message;

  ErrorResponse({required this.success, required this.message});

  factory ErrorResponse.fromJson(dynamic json) {
    return ErrorResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
