class AndroidDevice {
  String? Android;
  String? id;
  String? brand;

  // AndroidDevice(this.Android, this.brand, AndroidDeviceInfo androidInfo) : id = androidInfo.id;
  AndroidDevice(this.Android, this.brand, this.id);

  // Other methods or properties...

  Map<String, dynamic> toJson() {
    return {
      'platform': Android,
      'id': id,
      'brand': brand,
    };
  }
}
