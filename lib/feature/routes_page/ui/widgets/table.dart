import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/moving/moving_gate/cubit/moving_gate_order_data_cubit.dart';
import 'package:virok_wms/feature/routes_page/model/order.dart';
import 'package:virok_wms/models/noms_model.dart';

import 'package:virok_wms/ui/widgets/widgets.dart';

import '../../../../../ui/theme/theme.dart';

class CustomTable extends StatelessWidget {
  const CustomTable({super.key, required this.orders, required this.docId});

  final List<OrderData> orders;
  final String docId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final MyColors myColors = Theme.of(context).extension<MyColors>()!;
    return Expanded(
      child: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];

          // Determine the background color based on conditions
          Color backgroundColor;
          if (order.orderPlacesCount == order.scannedCount) {
            backgroundColor =
                const Color.fromARGB(171, 76, 175, 79); // All items scanned
          } else if (order.scannedCount > 0) {
            backgroundColor =
                const Color.fromARGB(171, 255, 235, 59); // Some items scanned
          } else {
            backgroundColor = Colors.red; // No items scanned
          }

          return Container(
            color: backgroundColor, // Set the background color
            child: TableElement(
              dataLenght: orders.length,
              rowElement: [
                RowElement(
                  flex: 3,
                  value: order.orderNumber,
                  textStyle: theme.textTheme.labelSmall?.copyWith(
                      letterSpacing: 0.5,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 14),
                ),
                RowElement(
                  flex: 2,
                  value: order.orderPlacesCount.toString(),
                  textStyle: theme.textTheme.labelMedium
                      ?.copyWith(fontWeight: FontWeight.w500, fontSize: 10),
                ),
                RowElement(
                  flex: 2,
                  value: order.scannedCount.toString(),
                  textStyle: theme.textTheme.labelMedium,
                ),
              ],
              index: index,
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
  final Nom nom;
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
              : nom.isMyne == 1
                  ? const Color.fromARGB(248, 255, 255, 91)
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
            flex: 8,
            value: nom.name,
            textStyle: theme.textTheme.labelSmall?.copyWith(
                letterSpacing: 0.5,
                overflow: TextOverflow.ellipsis,
                fontSize: 9),
          ),
          RowElement(
            flex: 2,
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
