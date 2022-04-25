import 'package:flutter/material.dart';
import '/helper/constant/shared_prefs_const.dart';
import '/helper/utility/app_shared_prefs.dart';
class UserInfoProvider with ChangeNotifier {
  String userFullName = "";
  String userRoleName = "";
  int userRoleId= 0;

  void setUserInfo() async {
    userFullName = await AppSharedPrefs.getString(SharedPrefsConst.userFullName);
    userRoleName = await AppSharedPrefs.getString(SharedPrefsConst.userRoleName);
    userRoleId = await AppSharedPrefs.getInt(SharedPrefsConst.userRoleId);
    notifyListeners();
  }

}