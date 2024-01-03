import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/admission/admission_placement/cubit/placement_cubit.dart';
import 'package:virok_wms/feature/admission/admission_placement/placement_repository/model/placement_nom.dart';
import 'package:virok_wms/ui/theme/theme.dart';
import 'package:virok_wms/ui/widgets/row_element.dart';

import 'widgets.dart';

class PlacementTable extends StatelessWidget {
  const PlacementTable({
    super.key,
    required this.noms,
  });

  final List<PlacementNom> noms;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: noms.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (noms[index].freeCount == 0) return;
              showNomScanDialog(context, noms[index]);

              context.read<PlacementCubit>().getNoms();
            },
            child: CustomTableRow(
              index: index,
              lastIndex: noms.length - 1,
              nom: noms[index],
            ),
          );
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
  final PlacementNom nom;
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
          color: nom.freeCount < nom.allCount
              ? AppColors.tableYellow
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
            flex: 2,
            value: (index + 1).toString(),
            textStyle: theme.textTheme.titleSmall?.copyWith(fontSize: 13),
          ),
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
                ?.copyWith(fontWeight: FontWeight.w500, fontSize: 12),
          ),
          RowElement(
            flex: 3,
            value: nom.allCount.toString(),
            textStyle: theme.textTheme.labelMedium,
          ),
          RowElement(
            flex: 3,
            value: nom.freeCount.toString(),
            textStyle: theme.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
