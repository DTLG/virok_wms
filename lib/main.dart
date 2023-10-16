import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/my_app.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp(
    isLogin: await isLogin(),
  ));
}

Future<bool> isLogin() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') != null &&
        prefs.getString('password') != null;
  } catch (e) {
    return false;
  }
}

