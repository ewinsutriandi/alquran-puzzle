import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String USER_NAME_KEY = 'USERNAME';
  static const String ALLOW_SOUND_KEY = 'ALLOW_SOUND';

  Future<void> saveUserName(String name) async {
    debugPrint('USER PREF: Saving user name');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(USER_NAME_KEY, name);
  }

  Future<String> get userName async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String s = prefs.getString(USER_NAME_KEY);
    if (s == null) return 'Pengguna Baru';
    return s;
  }

  Future<void> enableSound(bool enable) async {
    debugPrint('USER PREF: set sound fx enabled-> $enable');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(ALLOW_SOUND_KEY, enable);
  }

  Future<bool> get soundStatus async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool enable = prefs.getBool(ALLOW_SOUND_KEY);
    if (enable == null) return true;
    return enable;
  }
}
