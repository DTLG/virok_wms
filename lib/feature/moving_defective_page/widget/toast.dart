import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

void showToast(
  String message, {
  ToastGravity gravity = ToastGravity.BOTTOM,
  Color backgroundColor = Colors.black,
  Color textColor = Colors.white,
}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0);
}
