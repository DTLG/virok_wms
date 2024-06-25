import 'package:flutter/material.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';

import '../../../../../ui/theme/theme.dart';
import '../../moving_in_repository/models/noms_model.dart';
import 'dialog/count_input.dart';

class MovingInTable extends StatelessWidget {
  const MovingInTable({
    super.key,
    required this.noms,
  });

  final MovingInNoms noms;

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
              showManualCountIncrementAlert(
                  context, noms.noms[index], noms.invoice);
            },
            color: nom.qty == 0 || nom.count > nom.qty
                ? myColors.tableYellow
                : nom.count < nom.qty && nom.count != 0
                    ? myColors.tableRed
                    : nom.count == nom.qty
                        ? myColors.tableGreen
                        : index % 2 != 0
                            ? myColors.tableDarkColor
                            : myColors.tableLightColor,
          );

          // InkWell(
          //   onTap: () {
          //     showManualCountIncrementAlert(
          //         context, noms.noms[index], noms.invoice);
          //   },
          //   child: CustomTableRow(
          //     index: index,
          //     lastIndex: noms.noms.length - 1,
          //     nom: noms.noms[index],
          //   ),
          // );
        },
      ),
    );
  }
}

// class CustomTableRow extends StatelessWidget {
//   const CustomTableRow({
//     super.key,
//     required this.index,
//     required this.lastIndex,
//     required this.nom,
//   });
//   final MovingInNom nom;
//   final int index;
//   final int lastIndex;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Container(
//       margin: EdgeInsets.only(bottom: lastIndex == index ? 8 : 0),
//       height: 45,
//       padding: const EdgeInsets.all(3),
//       decoration: BoxDecoration(
//           color: nom.qty == 0 || nom.count > nom.qty
//               ? AppColors.tableYellow
//               : nom.count < nom.qty && nom.count != 0
//                   ? AppColors.tableRed
//                   : nom.count == nom.qty
//                       ? AppColors.tableGreen
//                       : index % 2 == 0
//                           ? Colors.grey[200]
//                           : Colors.white,
//           border: const Border.symmetric(
//               vertical: BorderSide(width: 1),
//               horizontal: BorderSide(width: 0.5)),
//           borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(lastIndex == index ? 15 : 0),
//               bottomRight: Radius.circular(lastIndex == index ? 15 : 0))),
//       child: Row(
//         children: [
//           RowElement(
//             flex: 6,
//             value: nom.name,
//             textStyle: theme.textTheme.labelSmall?.copyWith(
//                 letterSpacing: 0.5,
//                 overflow: TextOverflow.ellipsis,
//                 fontSize: 9),
//           ),
//           RowElement(
//             flex: 4,
//             value: nom.article,
//             textStyle: theme.textTheme.labelMedium
//                 ?.copyWith(fontWeight: FontWeight.w500, fontSize: 10),
//           ),
//           RowElement(
//             flex: 2,
//             value: nom.qty.toString(),
//             textStyle: theme.textTheme.labelMedium,
//           ),
//           RowElement(
//             flex: 2,
//             value: nom.count.toString(),
//             textStyle: theme.textTheme.labelMedium,
//           ),
//         ],
//       ),
//     );
//   }
// }
