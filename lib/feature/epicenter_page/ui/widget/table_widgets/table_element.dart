import 'package:flutter/material.dart';

class TableElement extends StatelessWidget {
  const TableElement({
    super.key,
    required this.dataLength,
    required this.rowElement,
    required this.index,
    required this.isExpanded,
    this.onTap,
    this.color,
    this.bottomMargin = 0,
    this.height = 45,
  });

  final int dataLength;
  final int index;
  final List<Widget> rowElement;
  final bool isExpanded;
  final GestureTapCallback? onTap;
  final Color? color;
  final double bottomMargin;
  final double height;

  @override
  Widget build(BuildContext context) {
    final lastIndex = dataLength - 1;

    return Container(
      // margin: EdgeInsets.only(
      //   bottom: lastIndex == index
      //       ? bottomMargin > 0
      //           ? bottomMargin
      //           : 5
      //       : 0,
      // ),
      height: height,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(width: 0.5),
        borderRadius: BorderRadius.only(
          // Заокруглення застосовується тільки для останнього елемента, якщо він не розгорнутий
          bottomLeft:
              Radius.circular(lastIndex == index && !isExpanded ? 10 : 0),
          bottomRight:
              Radius.circular(lastIndex == index && !isExpanded ? 10 : 0),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: rowElement,
        ),
      ),
    );
  }
}
