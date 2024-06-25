import 'package:flutter/material.dart';
import 'package:virok_wms/feature/returning/return_epic/model/return_epic_nom.dart';
import 'package:virok_wms/feature/returning/return_epic/ui/widgets/widgets.dart';
import '../../../../../../ui/ui.dart';

class ReturnEpicTable extends StatelessWidget {
  const ReturnEpicTable({super.key, required this.noms});

  final List<ReturnEpicNom> noms;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final MyColors myColors = Theme.of(context).extension<MyColors>()!;

    return Expanded(
      child: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: noms.length,
        itemBuilder: (context, index) {
          final nom = noms[index];
          return TableElement(
            dataLenght: noms.length,
            rowElement: [
              RowElement(
                flex: 6,
                value: nom.tovar,
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
                flex: 4,
                value: nom.incomingInvoiceNumber,
                textStyle: theme.textTheme.titleSmall!.copyWith(fontSize: 12),
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
              final barcode = noms[index].barcodes.isEmpty
                  ? ''
                  : noms[index].barcodes.first.barcode;

              if (barcode.isEmpty) {
                Alerts(
                        msg: 'Вибраному товару не присвоєний штрихкод',
                        context: context)
                    .showError();
                return;
              }
              manualCountIncrementDialog(context, barcode, nom);
            },
            color: nom.count == nom.qty
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
