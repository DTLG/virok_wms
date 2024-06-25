import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/return/cubits/return_data_cubit.dart';
import 'package:virok_wms/feature/return/return_repository/models/noms_model.dart';
import 'package:virok_wms/feature/return/return_repository/models/order.dart';
import 'package:virok_wms/ui/theme/theme.dart';

import 'package:virok_wms/ui/widgets/widgets.dart';

import 'dialog/count_input.dart';

class ReturningInTable extends StatelessWidget {
  const ReturningInTable({
    super.key,
    required this.noms,
    required this.order,
  });

  final ReturnNoms noms;
  final ReturnOrder order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final MyColors myColors = Theme.of(context).extension<MyColors>()!;
    return Expanded(
      child: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: noms.noms.length,
        itemBuilder: (context, index) {
          final nom = noms.noms[index];
          return TableElement(
            dataLenght: noms.noms.length,
            rowElement: [
              RowElement(
                flex: 6,
                value: nom.name,
                textStyle: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 0.5,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 9),
              ),
              RowElement(
                flex: 4,
                value: nom.article,
                textStyle: theme.textTheme.labelMedium
                    ?.copyWith(fontWeight: FontWeight.w500, fontSize: 10),
              ),
                 RowElement(
                flex: 3,
                value: nom.nomStatus,
                textStyle: theme.textTheme.labelMedium
                    ?.copyWith(fontWeight: FontWeight.w500, fontSize: 10),
              ),
              RowElement(
                flex: 2,
                value: nom.qty.toString(),
                textStyle: theme.textTheme.labelMedium,
              ),
              RowElement(
                flex: 2,
                value: nom.count.toString(),
                textStyle: theme.textTheme.labelMedium,
              ),
            ],
            index: index,
            onTap: () {
              final barcode = noms.noms[index].barcode.isEmpty
                  ? ''
                  : noms.noms[index].barcode.first.barcode;

              if (barcode.isEmpty) {
                Alerts(
                        msg: 'Вибраному товару не присвоєний штрихкод',
                        context: context)
                    .showError();
                return;
              }
              showManualCountIncrementAlert(
                  context, barcode, noms.invoice, noms.noms[index]);
              context.read<ReturnDataCubit>().getNoms(order);
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
