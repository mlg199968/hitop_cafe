class WindowsDevice {
  String? Windows;
  String? computerName;
  String? buildNumber;

  // WindowsDevice(this.Android, this.brand, AndroidDeviceInfo androidInfo) : id = androidInfo.id;
  WindowsDevice(this.Windows, this.computerName, this.buildNumber);

  // Other methods or properties...

  Map<String, dynamic> toJson() {
    return {
      'platform': Windows,
      'id': computerName,
      'brand': buildNumber,
    };
  }
}
