import 'package:flutter/material.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';

class TableHead extends StatelessWidget {
  const TableHead({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TableHeads(
      children: [
        RowElement(
          flex: 3,
          value: "Номер",
          textStyle: theme.textTheme.labelMedium,
        ),
        RowElement(
          flex: 2,
          value: "Місць",
          textStyle: theme.textTheme.labelMedium,
        ),
        RowElement(
          flex: 2,
          value: "Проскановано",
          textStyle: theme.textTheme.labelMedium,
        ),
      ],
    );
  }
}
