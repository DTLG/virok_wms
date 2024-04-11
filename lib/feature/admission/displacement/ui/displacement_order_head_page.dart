import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/route/app_routes.dart';


import 'package:virok_wms/ui/widgets/widgets.dart';

import '../../../../ui/theme/theme.dart';
import '../cubits/displacement_order_head_cubit.dart';
import '../models/models.dart';

class DisplacementOrdersHeadPage extends StatelessWidget {
  const DisplacementOrdersHeadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DisplacementOrdersHeadCubit(),
      child: const DisplacementOrdersHeadView(),
    );
  }
}

class DisplacementOrdersHeadView extends StatelessWidget {
  const DisplacementOrdersHeadView({super.key});

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
          'Прийом товару',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
        child: Column(
          children: [
            const _TableHead(),
            BlocConsumer<DisplacementOrdersHeadCubit,
                DisplacementOrdersHeadState>(
              listener: (context, state) {
                if (state.status.isNotFound) {
                  Alerts(msg: state.errorMassage, context: context).showError();
                }
              },
              builder: (context, state) {
                if (state.status.isInitial) {
                  context.read<DisplacementOrdersHeadCubit>().getOrders();
                  return const Expanded(
                      child: Center(child: CircularProgressIndicator()));
                }
                if (state.status.isLoading) {
                  return const Expanded(
                      child: Center(child: CircularProgressIndicator()));
                }
                if (state.status.isFailure) {
                  return Expanded(
                    child: WentWrong(
                      onPressed: () => context
                          .read<DisplacementOrdersHeadCubit>()
                          .getOrders(),
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
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GeneralButton(
              lable: 'Оновити',
              onPressed: () {
                context.read<DisplacementOrdersHeadCubit>().getOrders();
              })
        ],
      ),
    );
  }
}

class _CustomTable extends StatelessWidget {
  const _CustomTable({required this.orders});

  final DisplacementOrders orders;

  @override
  Widget build(BuildContext context) {
    orders.orders.sort((a, b) => b.date.compareTo(a.date));
    final theme = Theme.of(context);
    final MyColors myColors = Theme.of(context).extension<MyColors>()!;

    return Expanded(
      child: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: orders.orders.length,
        itemBuilder: (context, index) {
          return TableElement(
            dataLenght: orders.orders.length,
            rowElement: [
              RowElement(
                  flex: 2,
                  value: (index + 1).toString(),
                  textStyle: theme.textTheme.titleSmall!.copyWith()),
              RowElement(
                  flex: 3,
                  value: orders.orders[index].docId,
                  textStyle: theme.textTheme.titleSmall),
              RowElement(
                flex: 6,
                value: orders.orders[index].customer,
                textStyle: theme.textTheme.titleSmall!.copyWith(fontSize: 12),
              ),
              RowElement(
                  flex: 4,
                  value: orders.orders[index].date,
                  textStyle: theme.textTheme.titleSmall),
            ],
            index: index,
            onTap: () {
              if (orders.orders[index].invoice == '0') {
                showStartReceivingDialog(context, orders.orders[index]);
              } else {
                Navigator.pushNamed(
                    context, AppRoutes.displacementorderDataPage,
                    arguments: {
                      'order': orders.orders[index],
                      'cubit': context.read<DisplacementOrdersHeadCubit>()
                    });
              }
            },
            color: orders.orders[index].invoice != '0'
                ? myColors.tableYellow
                : index % 2 != 0
                    ? myColors.tableDarkColor
                    : myColors.tableLightColor,
          );
        },
      ),
    );
  }
}

TextStyle colorStyle(TextStyle? style, bool arg) {
  return style!.copyWith(color: arg ? Colors.black : Colors.white);
}

class _TableHead extends StatelessWidget {
  const _TableHead();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TableHeads(children: [
      RowElement(
        flex: 2,
        value: "№",
        textStyle: theme.textTheme.titleSmall,
      ),
      RowElement(
        flex: 3,
        value: "№ док.",
        textStyle: theme.textTheme.titleSmall,
      ),
      RowElement(
        flex: 6,
        value: "Постачальник",
        textStyle: theme.textTheme.titleSmall,
      ),
      RowElement(
        flex: 4,
        value: "Дата",
        textStyle: theme.textTheme.titleSmall,
      ),
    ]);
  }
}

showStartReceivingDialog(BuildContext context, DisplacementOrder order) {
  showDialog(
    context: context,
    builder: (_) => BlocProvider.value(
      value: context.read<DisplacementOrdersHeadCubit>(),
      child: StartReceivingDialog(
        order: order,
      ),
    ),
  );
}

class StartReceivingDialog extends StatelessWidget {
  const StartReceivingDialog({super.key, required this.order});
  final DisplacementOrder order;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      iconPadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.only(bottom: 20),
      actionsPadding: const EdgeInsets.only(bottom: 5),
      icon: Align(
          alignment: Alignment.centerRight,
          child: IconButton(
              constraints: const BoxConstraints(),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close))),
      content: const Text(
        'Розпочати прийом товару?',
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.displacementorderDataPage,
                  arguments: {
                    'order': order,
                    'cubit': context.read<DisplacementOrdersHeadCubit>()
                  });
            },
            child: const Text(
              'Розпочати',
            ))
      ],
    );
  }
}
