import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class TableHeads extends StatelessWidget {
  const TableHeads({super.key, required this.children});

final List<Widget> children;

  @override
  Widget build(BuildContext context) {
            final MyColors myColors = Theme.of(context).extension<MyColors>()!;

    return Container(
      height: 45,
      decoration:  BoxDecoration(
        color: myColors.tableDarkColor,
          border: const Border.symmetric(
              vertical: BorderSide(width: 1),
              horizontal: BorderSide(width: 0.5)),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Row(
        children: children
      ),
    );
  }
}
