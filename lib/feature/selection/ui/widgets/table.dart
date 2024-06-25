import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/selection/cubit/selection_order_data_cubit.dart';
import 'package:virok_wms/models/noms_model.dart';
import 'package:virok_wms/ui/ui.dart';

import 'dialog/nom_scan.dart';

class CustomTable extends StatelessWidget {
  const CustomTable({super.key, required this.noms, required this.docId});

  final List<Nom> noms;
  final String docId;

  @override
  Widget build(BuildContext context) {
    noms.sort((a, b) => a.nameCell.compareTo(b.nameCell));
        final theme = Theme.of(context);
        final MyColors myColors = Theme.of(context).extension<MyColors>()!;
    return Expanded(
      child: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: noms.length,
        itemBuilder: (context, index) {
          return 
          
          TableElement(dataLenght: noms.length, rowElement: [      RowElement(
            flex: 6,
            value: noms[index].name,
            textStyle: theme.textTheme.labelSmall?.copyWith(
                letterSpacing: 0.5,
                overflow: TextOverflow.ellipsis,
                fontSize: 9),
          ),
          RowElement(
            flex: 4,
            value: noms[index].article,
            textStyle: theme.textTheme.labelMedium
                ?.copyWith(fontWeight: FontWeight.w500, fontSize: 10),
          ),
          RowElement(
            flex: 6,
            value: noms[index].nameCell,textStyle: theme.textTheme.titleSmall!.copyWith(fontSize: 12),
          ),
          RowElement(
            flex: 2,
            value: noms[index].qty.toString(),
            textStyle: theme.textTheme.labelMedium,
          ),
          RowElement(
            flex: 2,
            value: noms[index].count.toString(),
            textStyle: theme.textTheme.labelMedium,
          ),], index: index,
            color: noms[index].count == noms[index].qty
              ? myColors.tableGreen
              : noms[index].isMyne == 1
                  ? myColors.tableYellow
                  : index % 2 != 0
                      ? myColors.tableLightColor
                      : myColors.tableDarkColor,
                      onTap: (){
                           if (noms[index].isMyne == 1) {
                if (noms[index].count < noms[index].qty) {
                  final barcode = noms[index].barcode.isEmpty
                      ? ''
                      : noms[index].barcode.first.barcode;

                  if (barcode.isEmpty) {
                    Alerts(
                            msg: 'Вибраному товару не присвоєний штрихкод',
                            context: context)
                        .showError();
                    return;
                  }
                  showNomInput(
                      context,
                      docId,
                      noms[index].barcode.isEmpty
                          ? ''
                          : noms[index].barcode.first.barcode,
                      noms[index].codeCell,
                      noms[index]);
                      context.read<SelectionOrderDataCubit>().getNoms(docId);
                }
              } else {
                Alerts(msg: "Товар в зоні іншого користувача", context: context)
                    .showError();
              }
                      },);

          
          
          

        },
      ),
    );
  }
}
