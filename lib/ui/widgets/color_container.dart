import 'package:flutter/material.dart';

class ColorContainer extends StatelessWidget {
  const ColorContainer({super.key, required this.child, required this.color});

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: color),
        child: child);
  }
}
