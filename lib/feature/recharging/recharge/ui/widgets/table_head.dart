
import 'package:flutter/material.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';

class RechargeTableHead extends StatelessWidget {
  const RechargeTableHead({super.key, });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TableHeads(
     
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
         
          RowElement(
            flex: 2,
            value: "К-ть",
            textStyle: theme.textTheme.labelMedium,
          ),
      
        ],
    );
  }
}
