
import 'package:flutter/material.dart';

class SettingProvider extends ChangeNotifier{
  bool doStorageChange=false;

  storageChangeBool(bool val){
    doStorageChange=val;
    notifyListeners();
  }
}