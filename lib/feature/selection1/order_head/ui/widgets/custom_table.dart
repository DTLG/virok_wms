
import 'package:flutter/material.dart';
import 'package:virok_wms/models/orders.dart';
import 'package:virok_wms/ui/widgets/row_element.dart';

class CustomTable extends StatelessWidget {
  const CustomTable({super.key, required this.orders});

  final List<Order> orders;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/selection_head/selection_data', arguments: orders[index]);
            },
            child: CustomTableRow(
              index: index,
              lastIndex: orders.length - 1,
              order: orders[index],
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
      required this.order});
  final Order order;
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
          color: index % 2 == 0 ? Colors.grey[200] : Colors.white,
          border: const Border.symmetric(
              vertical: BorderSide(width: 1),
              horizontal: BorderSide(width: 0.5)),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(lastIndex == index ? 8 : 0),
              bottomRight: Radius.circular(lastIndex == index ? 8 : 0))),
      child: Row(
        children: [
          RowElement(
            flex: 1,
            value: (index + 1).toString(),
            textStyle: theme.textTheme.labelSmall
                ?.copyWith(letterSpacing: 0.5, overflow: TextOverflow.ellipsis),
          ),
          RowElement(
            flex: 4,
            value: order.docId,
            textStyle: theme.textTheme.labelMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          RowElement(
            flex: 4,
            value: order.date,
            textStyle: theme.textTheme.labelMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
