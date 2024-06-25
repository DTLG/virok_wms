import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/admission/displacement/cubits/displacement_order_data_cubit.dart';
import 'package:virok_wms/ui/ui.dart';

import '../../models/models.dart';
import 'dialog/count_input.dart';

class DisplacementTable extends StatelessWidget {
  const DisplacementTable({super.key, required this.noms, required this.order});

  final DisplacementNoms noms;
  final DisplacementOrder order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final MyColors myColors = Theme.of(context).extension<MyColors>()!;

    return Expanded(
      child: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: noms.noms.length,
        itemBuilder: (context, index) {
          return TableElement(
            dataLenght: noms.noms.length,
            rowElement: [
              RowElement(
                flex: 2,
                value: (index + 1).toString(),
                textStyle: theme.textTheme.titleSmall?.copyWith(fontSize: 13),
              ),
              RowElement(
                flex: 6,
                value: noms.noms[index].name,
                textStyle: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 0.5,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 9),
              ),
              RowElement(
                flex: 4,
                value: noms.noms[index].article,
                textStyle: theme.textTheme.labelMedium
                    ?.copyWith(fontWeight: FontWeight.w500, fontSize: 10),
              ),
              RowElement(
                flex: 2,
                value: noms.noms[index].qty.toString(),
                textStyle: theme.textTheme.labelMedium,
              ),
              RowElement(
                flex: 2,
                value: noms.noms[index].count.toString(),
                textStyle: theme.textTheme.labelMedium,
              ),
            ],
            index: index,
            onTap: () {
              final barcode = noms.noms[index].barcodes.isEmpty
                  ? ''
                  : noms.noms[index].barcodes.first.barcode;

              if (barcode.isEmpty) {
                Alerts(
                        msg: 'Вибраному товару не присвоєний штрихкод',
                        context: context)
                    .showError();
                return;
              }
              showManualCountIncrementAlert(
                  context, barcode, noms.invoice, noms.noms[index]);
              context.read<DisplacementOrderDataCubit>().getNoms(order);
            },
            color: noms.noms[index].qty == 0 ||
                    noms.noms[index].count > noms.noms[index].qty
                ? myColors.tableYellow
                : noms.noms[index].count < noms.noms[index].qty &&
                        noms.noms[index].count != 0
                    ? myColors.tableRed
                    : noms.noms[index].count == noms.noms[index].qty
                        ? myColors.tableGreen
                        : index % 2 != 0
                            ? myColors.tableDarkColor
                            : myColors.tableLightColor,
          );
        },
      ),
    );
  }
}
