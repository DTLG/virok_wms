import 'package:flutter/material.dart';

class TableElement extends StatelessWidget {
  const TableElement({
    super.key,
    required this.dataLenght,
    required this.rowElement,
    required this.index,
    this.onTap,
    this.color,
    this.bottomMargin = 0,
    this.height = 45,
  });

  final int dataLenght;
  final int index;
  final List<Widget> rowElement;
  final GestureTapCallback? onTap;
  final Color? color;
  final double bottomMargin;
  final double height;

  @override
  Widget build(BuildContext context) {
    final lastIndex = dataLenght - 1;

    return Container(
      margin: EdgeInsets.only(
          bottom: lastIndex == index
              ? bottomMargin > 0
                  ? bottomMargin
                  : 5
              : 0),
      height: height,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(width: 0.5), // Коректне використання бордерів
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(lastIndex == index ? 10 : 0),
          bottomRight: Radius.circular(lastIndex == index ? 10 : 0),
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
