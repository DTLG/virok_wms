import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/admission/kyiv_placement/placement_from_return/cubit/placement_cubit.dart';
import 'package:virok_wms/feature/admission/placement/placement_repository/model/admission_nom.dart';

import '../../../../../../ui/ui.dart';
import 'widgets.dart';

class PlacementTable extends StatelessWidget {
  const PlacementTable({super.key, required this.noms});

  final List<AdmissionNom> noms;

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
                flex: 4,
                value: nom.nameCell,textStyle: theme.textTheme.titleSmall!.copyWith(fontSize: 12),
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

              if (noms[index].count < noms[index].qty) {
                showPlacementNomScanDialog(context, noms[index]);
                context.read<PlacementFromReturnCubit>().getNoms();
              }
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
