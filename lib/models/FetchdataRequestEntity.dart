class FetchdataRequestEntity {
  // int? id;
  String? phone;
  Map<String, dynamic>? deviceId;
  // String? deviceId;

  FetchdataRequestEntity({
    // this.id,
    this.phone,
    this.deviceId,
  });

  Map<String, dynamic> toJson() => {
        // "id": id,
        "phone": phone,
        "deviceId": deviceId,
      };
}
