import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/admission/placement/cubit/placement_cubit.dart';
import 'package:virok_wms/feature/admission/placement/placement_repository/model/admission_nom.dart';
import 'package:virok_wms/feature/admission/placement/placement_repository/model/placement_order.dart';

import 'package:virok_wms/ui/widgets/widgets.dart';

import '../../../../../ui/theme/theme.dart';
import 'widgets.dart';

class PlacementTable extends StatelessWidget {
  const PlacementTable({super.key, required this.noms, required this.order});

  final List<AdmissionNom> noms;
  final PlacementOrder order;

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
                context.read<PlacementCubit>().getNoms(order.incomingInvoice);
              }
            },
            color: nom.count == nom.qty
                ? myColors.tableGreen
                : index % 2 != 0
                    ? myColors.tableDarkColor
                    : myColors.tableLightColor,
          );

//           InkWell(
//             onTap: () {
//  final barcode = noms[index].barcodes.isEmpty
//                   ? ''
//                   : noms[index].barcodes.first.barcode;

//               if (barcode.isEmpty) {
//                 Alerts(msg: 'Вибраному товару не присвоєний штрихкод', context: context).showError();
//                 return;
//               }

//               if (noms[index].count < noms[index].qty) {
//                 showPlacementNomScanDialog(context, noms[index]);
//                 context.read<PlacementCubit>().getNoms();
//               }
//             },
//             child: CustomTableRow(
//               index: index,
//               lastIndex: noms.length - 1,
//               nom: noms[index],
//             ),
//           );
        },
      ),
    );
  }
}

class CustomTableRow extends StatelessWidget {
  const CustomTableRow({
    super.key,
    required this.index,
    required this.lastIndex,
    required this.nom,
  });
  final AdmissionNom nom;
  final int index;
  final int lastIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: lastIndex == index ? 8 : 0),
      height: 45,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
          color: nom.count == nom.qty
              ? const Color.fromARGB(255, 132, 255, 142)
              : index % 2 == 0
                  ? Colors.grey[200]
                  : Colors.white,
          border: const Border.symmetric(
              vertical: BorderSide(width: 1),
              horizontal: BorderSide(width: 0.5)),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(lastIndex == index ? 15 : 0),
              bottomRight: Radius.circular(lastIndex == index ? 15 : 0))),
      child: Row(
        children: [
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
            value: nom.nameCell,textStyle: theme.textTheme.titleSmall,
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
      ),
    );
  }
}
