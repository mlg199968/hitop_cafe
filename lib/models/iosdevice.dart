class IosDevice {
  String? ios;
  String? identifierForVendor;
  String? name;

  // IosDevice(this.Android, this.brand, AndroidDeviceInfo androidInfo) : id = androidInfo.id;
  IosDevice(this.ios, this.identifierForVendor, this.name);

  // Other methods or properties...

  Map<String, dynamic> toJson() {
    return {
      'platform': ios,
      'id': identifierForVendor,
      'brand': name,
    };
  }
}
