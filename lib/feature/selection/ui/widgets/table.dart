import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/selection/cubit/selection_order_data_cubit.dart';
import 'package:virok_wms/models/noms_model.dart';
import 'package:virok_wms/ui/widgets/alerts.dart';
import 'package:virok_wms/ui/widgets/row_element.dart';

import 'dialog/nom_scan.dart';

class CustomTable extends StatelessWidget {
  const CustomTable({super.key, required this.noms});

  final List<Nom> noms;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: noms.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (noms[index].isMyne == 1) {
                if (noms[index].count < noms[index].qty) {
                  showNomInput(context, noms[index]);
                }
              } else {
                Alerts(msg: "Товар в зоні іншого користувача", context: context)
                    .showError();
              }
            },
            child: 
             CustomTableRow(
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
  const CustomTableRow(
      {super.key,
      required this.index,
      required this.lastIndex,
      required this.nom,
      });
  final Nom nom;
  final int index;
  final int lastIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final itsMezonone = context.read<SelectionOrderDataCubit>().state.itsMezonine;
    return Container(
      margin: EdgeInsets.only(bottom: lastIndex == index ? 8 : 0),
      height: 45,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
          color: nom.count == nom.qty
              ? const Color.fromARGB(255, 132, 255, 142)
              : nom.isMyne == 1
                  ? const Color.fromRGBO(249, 255, 137, 1)
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
            value: nom.nameCell,
            textStyle: theme.textTheme.labelMedium
                ?.copyWith(fontWeight: FontWeight.w500, fontSize: 10),
          ),
          // RowElement(
          //   flex: 3,
          //   value: itsMezonone ? nom.basckets.first.name : nom.table,
          //   textStyle: theme.textTheme.labelMedium?.copyWith(
          //       fontWeight: FontWeight.w500,
          //       fontSize: 11,
          //       color: const Color.fromARGB(255, 0, 19, 186)),
          // ),
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
