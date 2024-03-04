
import 'package:flutter/material.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';

class TableHead extends StatelessWidget {
  const TableHead({super.key, });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TableHeads(children: [
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
          RowElement(
            flex: 6,
            value: "Комірка",
            textStyle: theme.textTheme.labelMedium,
          ),
        
          RowElement(
            flex: 2,
            value: "К-ть",
            textStyle: theme.textTheme.labelMedium,
          ),
          RowElement(
            flex: 2,
            value: "Скан.",
            textStyle: theme.textTheme.labelMedium,
          ),
    ]);
    
    
    
    
    // Container(
    //   height: 45,
    //   decoration: const BoxDecoration(
    //       border: Border.symmetric(
    //           vertical: BorderSide(width: 1),
    //           horizontal: BorderSide(width: 0.5)),
    //       borderRadius: BorderRadius.only(
    //           topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    //   child: Row(
    //     children: [
    //        RowElement(
    //         flex: 6,
    //         value: "Товар",
    //         textStyle: theme.textTheme.labelMedium,
    //       ),
    //       RowElement(
    //         flex: 4,
    //         value: "Артикул",
    //         textStyle: theme.textTheme.labelMedium,
    //       ),
    //       RowElement(
    //         flex: 6,
    //         value: "Комірка",
    //         textStyle: theme.textTheme.labelMedium,
    //       ),
        
    //       RowElement(
    //         flex: 2,
    //         value: "К-ть",
    //         textStyle: theme.textTheme.labelMedium,
    //       ),
    //       RowElement(
    //         flex: 2,
    //         value: "Скан.",
    //         textStyle: theme.textTheme.labelMedium,
    //       ),
    //     ],
    //   ),
    // );
  }
}
