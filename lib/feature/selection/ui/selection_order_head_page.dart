import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/selection/cubit/selection_order_head_cubit.dart';
import 'package:virok_wms/models/order.dart';

import 'package:virok_wms/ui/widgets/widgets.dart';

import '../../../ui/widgets/alerts.dart';
import '../../../ui/widgets/row_element.dart';

class SelectioOrdersHeadPage extends StatelessWidget {
  const SelectioOrdersHeadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectionOrdersHeadCubit(),
      child: const SelectionOrdersHeadView(),
    );
  }
}

class SelectionOrdersHeadView extends StatelessWidget {
  const SelectionOrdersHeadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        title: const Text(
          'Завдання на відбір',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const _TableHead(),
            BlocConsumer<SelectionOrdersHeadCubit, SelectioOrdersHeadState>(
              listener: (context, state) {
                if (state.status.isNotFound) {
                  Alerts(msg: state.errorMassage, context: context).showError();
                }
              },
              builder: (context, state) {
                if (state.status.isInitial) {
                  context.read<SelectionOrdersHeadCubit>().getOrders();
                }
                if (state.status.isLoading) {
                  return const Expanded(
                      child: Center(child: CircularProgressIndicator()));
                }
                if (state.status.isFailure) {
                  return Expanded(
                    child: WentWrong(
                      onPressed: () =>
                          context.read<SelectionOrdersHeadCubit>().getOrders(),
                      errorDescription: state.errorMassage,
                    ),
                  );
                }
                if (state.status.isSuccess) {
                  return _CustomTable(
                    orders: state.orders,
                  );
                }
                return const Center();
              },
            )
          ],
        ),
      ),
    );
  }
}

class _CustomTable extends StatelessWidget {
  const _CustomTable({required this.orders});

  final Orders orders;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: orders.orders.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (orders.orders[index].baskets.isEmpty) {
                showDialog(
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: context.read<SelectionOrdersHeadCubit>(),
                    child: SetBuscetDialog(
                      docId: orders.orders[index].docId,
                    ),
                  ),
                );
              } else {
                Navigator.pushNamed(context, '/selection_P', arguments: {
                  'docId': orders.orders[index].docId,
                  'cubit': context.read<SelectionOrdersHeadCubit>()
                });
              }
            },
            child: _CustomTableRow(
              index: index,
              lastIndex: orders.orders.length - 1,
              order: orders.orders[index],
            ),
          );
        },
      ),
    );
  }
}

class _CustomTableRow extends StatelessWidget {
  const _CustomTableRow(
      {required this.index, required this.lastIndex, required this.order});
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
              bottomLeft: Radius.circular(lastIndex == index ? 15 : 0),
              bottomRight: Radius.circular(lastIndex == index ? 15 : 0))),
      child: Row(
        children: [
          RowElement(
              flex: 1,
              value: (index + 1).toString(),
              textStyle: theme.textTheme.titleSmall),
          RowElement(
              flex: 4,
              value: order.docId,
              textStyle: theme.textTheme.titleSmall),
          RowElement(
              flex: 4,
              value: order.date,
              textStyle: theme.textTheme.titleSmall),
        ],
      ),
    );
  }
}

class _TableHead extends StatelessWidget {
  const _TableHead();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 45,
      decoration: const BoxDecoration(
          border: Border.symmetric(
              vertical: BorderSide(width: 1),
              horizontal: BorderSide(width: 0.5)),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Row(
        children: [
          RowElement(
            flex: 1,
            value: "№",
            textStyle: theme.textTheme.titleSmall,
          ),
          RowElement(
            flex: 4,
            value: "№ документу",
            textStyle: theme.textTheme.titleSmall,
          ),
          RowElement(
            flex: 4,
            value: "Дата",
            textStyle: theme.textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}

class SetBuscetDialog extends StatefulWidget {
  const SetBuscetDialog({super.key, required this.docId});

  final String docId;

  @override
  State<SetBuscetDialog> createState() => _SetBuscetDialogState();
}

class _SetBuscetDialogState extends State<SetBuscetDialog> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      iconPadding: EdgeInsets.zero,
      icon: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 50),
          const Text(
            'Присвоєння кошика',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close))
        ],
      ),
      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: "Відскануйте кошик"),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: EdgeInsets.zero,
      actions: [
        GeneralButton(
            lable: 'Присвоїти',
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                bool status = await context
                    .read<SelectionOrdersHeadCubit>()
                    .setBasketToOrder(controller.text, widget.docId);

                if (status == true) {
                  if (!mounted) return;

                  Navigator.pushNamed(context, '/selection_P',
                      arguments: {'docId': widget.docId, '': ''});
                }
              }
            })
      ],
    );
  }
}
