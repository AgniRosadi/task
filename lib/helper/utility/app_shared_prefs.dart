
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/shared_prefs_const.dart';

class AppSharedPrefs {

  //set prefs value
  static Future<bool> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }
  static Future<bool> setInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setInt(key, value);
  }
  static Future<bool> setDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setDouble(key, value);
  }
  static Future<bool> setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key, value);
  }
  static Future<bool> setStringList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(key, value);
  }

  //get prefs value
  static Future<String> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    var res = prefs.getString(key);
    return res ?? "";
  }

  static Future<int> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    var res = prefs.getInt(key);
    return res ?? 0;
  }

  static Future<double> getDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    var res = prefs.getDouble(key);
    return res ?? 0;
  }

  static Future<bool> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    var res = prefs.getBool(key);
    return res ?? false;
  }

  static Future<List<String>> getStringList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    var res = prefs.getStringList(key);
    return res ?? [];
  }

  //get set value token
  static Future<bool> setToken(String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(SharedPrefsConst.authToken, value);
  }
  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    var res = prefs.getString(SharedPrefsConst.authToken);
    return res ?? "";
  }

  //get set value login status
  static Future<bool> setLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(SharedPrefsConst.isLoggedIn, value);
  }
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    var res = prefs.getBool(SharedPrefsConst.isLoggedIn);
    return res ?? false;
  }

}