class SubscriptionData {
  String? phone;
  String? deviceId;
  int? level;
  String? platform;
  String? name;
  String? email;
  String? startDate;
  String? endDate;
  String? refId;
  String? authority;
  String? status;
  String? description;
  int? amount;

  SubscriptionData({
    this.phone,
    this.deviceId,
    this.level,
    this.platform,
    this.name,
    this.email,
    this.startDate,
    this.endDate,
    this.refId,
    this.authority,
    this.status,
    this.description,
    this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      "phone": phone,
      "deviceId": deviceId,
      "level": level,
      "platform": platform,
      "name": name,
      "email": email,
      "start_date": startDate,
      "end_date": endDate,
      "ref_id": refId,
      "Authority": authority,
      "Status": status,
      "description": description,
      "amount": amount,
    };
  }
}
