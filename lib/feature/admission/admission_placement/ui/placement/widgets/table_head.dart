
import 'package:flutter/material.dart';
import 'package:virok_wms/ui/widgets/row_element.dart';

class PlacementTableHead extends StatelessWidget {
  const PlacementTableHead({super.key, });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 45,
      decoration: const BoxDecoration(
          border: Border.symmetric(
              vertical: BorderSide(width: 1),
              horizontal: BorderSide(width: 0.5)),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Row(
        children: [
           RowElement(
            flex: 2,
            value: "№",
            textStyle: theme.textTheme.labelMedium,
          ),
          
  
           RowElement(
            flex: 6,
            value: "Товар",
            textStyle: theme.textTheme.labelMedium,
          ),
          RowElement(
            flex: 4,
            value: "Артикул",
            textStyle: theme.textTheme.labelMedium,
          ),
         
          const RowElement(
            flex: 3,
            value: "Залишок",
            textStyle: TextStyle(fontSize: 10),
          ),
          const RowElement(
            flex: 3,
            value: "Доступно",
            textStyle: TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
