import 'package:flutter/material.dart';
import 'package:virok_wms/ui/widgets/row_element.dart';

import '../../displacement_repository/models/noms_model.dart';
import 'dialog/count_input.dart';

class DisplacementTable extends StatelessWidget {
  const DisplacementTable({
    super.key,
    required this.noms,
  });

  final DisplacementNoms noms;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: noms.noms.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              showManualCountIncrementAlert(
                  context, noms.noms[index], noms.invoice);
            },
            child: CustomTableRow(
              index: index,
              lastIndex: noms.noms.length - 1,
              nom: noms.noms[index],
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
  final DisplacementNom nom;
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
          color: nom.qty == 0 || nom.count > nom.qty
              ? const Color.fromARGB(248, 255, 255, 159)
              : nom.count < nom.qty && nom.count != 0
                  ? const Color.fromARGB(248, 255, 149, 149)
                  : nom.count == nom.qty
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
