import 'package:flutter/material.dart';

class TableElement extends StatelessWidget {
  const TableElement(
      {super.key,
      required this.dataLenght,
      required this.rowElement,
      required this.index,
      this.onTap,  this.color});

  final int dataLenght;
  final int index;
  final List<Widget> rowElement;
  final GestureTapCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {

    final lastIndex = dataLenght - 1;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: lastIndex == index ? 8 : 0),
        height: 45,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: color,
            border: const Border.symmetric(
                vertical: BorderSide(width: 1),
                horizontal: BorderSide(width: 0.5)),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(lastIndex == index ? 10 : 0),
                bottomRight: Radius.circular(lastIndex == index ? 10 : 0))),
        child: Row(
          children: rowElement,
        ),
      ),
    );
  }
}
