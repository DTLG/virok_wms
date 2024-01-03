import 'package:flutter/material.dart';
import 'package:virok_wms/feature/recharge/recharge_repository/models/recharge_noms.dart';
import 'package:virok_wms/feature/recharge/ui/widgets/dialog.dart';
import 'package:virok_wms/ui/widgets/row_element.dart';

class RechargeTable extends StatelessWidget {
  const RechargeTable({
    super.key,
    required this.noms,
  });

  final List<RechargeNom> noms;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: noms.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              final nom = noms[index];
              if (nom.isStarted == 0) {
                checkIsStartedDialog(context, nom);
              } else {
                writeOffOrPlacement(context, nom);
              }
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
  final RechargeNom nom;
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
          color: nom.isStarted == 1
              ? const Color.fromARGB(255, 255, 245, 152)
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
            textStyle: theme.textTheme.labelSmall?.copyWith(
                letterSpacing: 0.5,
                overflow: TextOverflow.ellipsis,
                fontSize: 9),
          ),
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
            flex: 2,
            value: nom.qty.toString(),
            textStyle: theme.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
