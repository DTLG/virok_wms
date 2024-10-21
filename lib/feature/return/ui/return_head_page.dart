// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/return/cubits/return_head_cubit.dart';
import 'package:virok_wms/feature/return/return_repository/models/order.dart';
import 'package:virok_wms/route/app_routes.dart';
import 'package:virok_wms/ui/widgets/sound_interface.dart';

import 'package:virok_wms/ui/widgets/widgets.dart';

import '../../../../ui/theme/theme.dart';

SoundInterface soundInterface = SoundInterface();

class ReturnHeadPage extends StatelessWidget {
  const ReturnHeadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReturnHeadCubit(),
      child: const ReturnHeadView(),
    );
  }
}

class ReturnHeadView extends StatelessWidget {
  const ReturnHeadView({super.key});

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
          'Повернення на склад',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
        child: Column(
          children: [
            const _TableHead(),
            BlocConsumer<ReturnHeadCubit, ReturnHeadState>(
              listener: (context, state) {
                if (state.status.isNotFound) {
                  Alerts(msg: state.errorMassage, context: context).showError();
                }
              },
              builder: (context, state) {
                if (state.status.isInitial) {
                  context.read<ReturnHeadCubit>().getOrders();
                }
                if (state.status.isLoading) {
                  return const Expanded(
                      child: Center(child: CircularProgressIndicator()));
                }
                if (state.status.isFailure) {
                  () async {
                    soundInterface.play(Event.error);
                  };
                  return Expanded(
                    child: WentWrong(
                      onPressed: () =>
                          context.read<ReturnHeadCubit>().getOrders(),
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
                context.read<ReturnHeadCubit>().getOrders();
              })
        ],
      ),
    );
  }
}

class _CustomTable extends StatelessWidget {
  const _CustomTable({required this.orders});

  final ReturnOrders orders;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final MyColors myColors = Theme.of(context).extension<MyColors>()!;
    return Expanded(
      child: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: orders.orders.length,
        itemBuilder: (context, index) {
          final order = orders.orders[index];
          return TableElement(
            dataLenght: orders.orders.length,
            rowElement: [
              RowElement(
                  flex: 1,
                  value: (index + 1).toString(),
                  textStyle: theme.textTheme.titleSmall),
              RowElement(
                  flex: 3,
                  value: order.docId,
                  textStyle: theme.textTheme.titleSmall),
              RowElement(
                flex: 6,
                value: order.customer,
                textStyle: theme.textTheme.titleSmall!.copyWith(fontSize: 11),
              ),
              RowElement(
                  flex: 4,
                  value: order.date,
                  textStyle: theme.textTheme.titleSmall),
            ],
            index: index,
            onTap: () {
              if (orders.orders[index].invoice == '0') {
                _showStartReceivingDialog(context, orders.orders[index]);
              } else {
                Navigator.pushNamed(context, AppRoutes.returningInDataPage,
                    arguments: {
                      'order': orders.orders[index],
                      'cubit': context.read<ReturnHeadCubit>()
                    });
              }
            },
            color: order.invoice != '0'
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

class _TableHead extends StatelessWidget {
  const _TableHead();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TableHeads(
      children: [
        RowElement(
          flex: 1,
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
      ],
    );
  }
}

_showStartReceivingDialog(BuildContext context, ReturnOrder order) {
  showDialog(
    context: context,
    builder: (_) => BlocProvider.value(
      value: context.read<ReturnHeadCubit>(),
      child: _StartReceivingDialog(
        order: order,
      ),
    ),
  );
}

class _StartReceivingDialog extends StatelessWidget {
  const _StartReceivingDialog({super.key, required this.order});
  final ReturnOrder order;

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
              Navigator.pushNamed(context, AppRoutes.returningInDataPage,
                  arguments: {
                    'order': order,
                    'cubit': context.read<ReturnHeadCubit>()
                  });
            },
            child: const Text(
              'Розпочати',
            ))
      ],
    );
  }
}
