import 'package:hitop_cafe/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';



///setter and getter for default name for printer
late final SharedPreferences _prefs;

class StorageService {
  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

}
