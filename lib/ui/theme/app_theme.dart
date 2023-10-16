import 'package:flutter/material.dart';

abstract class AppTheme {
  static ThemeData theme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 111, 111, 111),
            )),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18))),
    appBarTheme: const AppBarTheme(
        centerTitle: true, backgroundColor: Color(0xFFB10000)),
    scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          textStyle: const MaterialStatePropertyAll(
              TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          backgroundColor: const MaterialStatePropertyAll(Color(0xFFB10000)),
          minimumSize: const MaterialStatePropertyAll(Size(60, 40)),
          maximumSize: const MaterialStatePropertyAll(Size(200, 50)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ))),
    ),
  );
}
