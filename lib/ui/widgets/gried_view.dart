import 'package:flutter/material.dart';

class GridButton extends StatelessWidget {
  const GridButton({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      primary: false,
      padding: EdgeInsets.zero,
      semanticChildCount: 6,
      childAspectRatio: (3 / 2.85),
      children: children,
    );
  }
}
