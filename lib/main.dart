import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/old_my_app.dart';

// //!____________Тип проекту____________________
// enum ProjectType { lviv, kyiv }

// extension ProjectTypeX on ProjectType {
//   bool get isLviv => this == ProjectType.lviv;
//   bool get isKiev => this == ProjectType.kyiv;
// }

// //*                             ____
// const projectType = ProjectType.kyiv;
// //*                             ‾‾‾‾
// //!________________________________

String appVersion = '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  appVersion = packageInfo.version;
  runApp(OldMyApp(
          savedThemeMode: savedThemeMode, isLogin: true) //await isLogin()) // 
      );
}

Future<bool> isLogin() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('zone') != null &&
        prefs.getString('password') != null;
  } catch (e) {
    return false;
  }
}
