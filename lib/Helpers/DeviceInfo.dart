import 'package:shared_preferences/shared_preferences.dart';

class DeviceInfo {

  static Future<SharedPreferences> loadSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

}