import 'package:flutter/material.dart';

class RowElement extends StatelessWidget {
  const RowElement(
      {super.key, required this.flex, required this.value, this.textStyle});

  final int flex;
  final String value;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: flex,
        child: Text(
          value.toString(),
          maxLines: 3,
          textAlign: TextAlign.center,
          style: textStyle,
        ));
  }
}
