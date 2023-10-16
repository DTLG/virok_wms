import 'package:flutter/material.dart';

import '../../../../../ui/widgets/row_element.dart';

class TableHead extends StatelessWidget {
  const TableHead({super.key, required this.rowElement});

  final List<RowElement> rowElement;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: const BoxDecoration(
          border: Border.symmetric(
              vertical: BorderSide(width: 1),
              horizontal: BorderSide(width: 0.5)),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Row(
        children: rowElement,
      ),
    );
  }
}
