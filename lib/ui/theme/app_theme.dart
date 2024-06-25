import 'package:flutter/material.dart';
import 'package:virok_wms/ui/ui.dart';

abstract class AppTheme {
  static ThemeData light = ThemeData(
      useMaterial3: false,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      inputDecorationTheme: inputDecorationTheme,
      appBarTheme: const AppBarTheme(
          centerTitle: true, backgroundColor: AppColors.darkRed),
      scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
      bottomSheetTheme:
          const BottomSheetThemeData(backgroundColor: Colors.white),
      floatingActionButtonTheme: floatingActionButtonTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      cardColor: AppColors.cardColorLight,
      extensions: const <ThemeExtension<dynamic>>[
        MyColors(
            tableLightColor: AppColors.tableLightLightTheme,
            tableDarkColor: AppColors.tabledarkLightTheme,
            tableGreen: AppColors.tableGreen,
            tableRed: AppColors.tableRed,
            tableYellow: AppColors.tableYellow)
      ]);

  static ThemeData dark = ThemeData.dark(
    useMaterial3: false,
  ).copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      inputDecorationTheme: inputDecorationTheme.copyWith(
          hintStyle: const TextStyle(color: Colors.grey)),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
      ),
      floatingActionButtonTheme: floatingActionButtonTheme.copyWith(backgroundColor: AppColors.tableLightDarktheme),
      elevatedButtonTheme: elevatedButtonTheme,
      cardColor: AppColors.cardColorDark,
      textTheme: const TextTheme(
          titleSmall: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white)),
      extensions: <ThemeExtension<dynamic>>[
        const MyColors(
            tableLightColor: AppColors.tableLightDarktheme,
            tableDarkColor: AppColors.tabledarkDarktheme,
            tableGreen: AppColors.tableGreenDarkTheme,
            tableRed: AppColors.tableRedDarkTheme,
            tableYellow: AppColors.tableYellowDarkTheme)
      ]);
}

final inputDecorationTheme = InputDecorationTheme(
  
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 111, 111, 111),
        )),
        
        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18),borderSide: BorderSide(color: Colors.grey[500]!)),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)));

final elevatedButtonTheme = ElevatedButtonThemeData(
  style: ButtonStyle(
      textStyle: const MaterialStatePropertyAll(
          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      backgroundColor: const MaterialStatePropertyAll(AppColors.darkRed),
      minimumSize: const MaterialStatePropertyAll(Size(60, 40)),
      maximumSize: const MaterialStatePropertyAll(Size(200, 50)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ))),
);

const floatingActionButtonTheme =
    FloatingActionButtonThemeData(backgroundColor: AppColors.darkRed);

@immutable
class MyColors extends ThemeExtension<MyColors> {
  const MyColors(
      {required this.tableLightColor,
      required this.tableDarkColor,
      required this.tableGreen,
      required this.tableRed,
      required this.tableYellow});

  final Color? tableLightColor;
  final Color? tableDarkColor;
  final Color? tableGreen;
  final Color? tableYellow;
  final Color? tableRed;

  @override
  MyColors copyWith(
      {Color? tableLightColor,
      Color? tableDarkColor,
      Color? tableGreen,
      Color? tableYellow,
      Color? tableRed}) {
    return MyColors(
        tableLightColor: tableLightColor ?? this.tableLightColor,
        tableDarkColor: tableDarkColor ?? this.tableDarkColor,
        tableGreen: tableGreen ?? this.tableGreen,
        tableRed: tableRed ?? this.tableRed,
        tableYellow: tableYellow ?? this.tableYellow);
  }

  @override
  MyColors lerp(ThemeExtension<MyColors>? other, double t) {
    if (other is! MyColors) {
      return this;
    }
    return MyColors(
      tableLightColor: Color.lerp(tableLightColor, other.tableLightColor, t),
      tableDarkColor: Color.lerp(tableDarkColor, other.tableDarkColor, t),
      tableGreen: Color.lerp(tableGreen, other.tableGreen, t),
      tableYellow: Color.lerp(tableYellow, other.tableYellow, t),
      tableRed: Color.lerp(tableRed, other.tableRed, t),
    );
  }

  @override
  String toString() =>
      'MyColors(tableLightColor: $tableLightColor, tableLightColor: $tableDarkColor),tableGreen: $tableGreen),tableYellow: $tableYellow),tableRed: $tableRed)';
}
