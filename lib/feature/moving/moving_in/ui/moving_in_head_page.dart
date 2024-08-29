import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/route/app_routes.dart';

import 'package:virok_wms/ui/widgets/widgets.dart';

import '../../../../ui/theme/theme.dart';
import '../cubits/moving_in_head_cubit.dart';
import '../moving_in_repository/models/order.dart';

class MovingInHeadPage extends StatelessWidget {
  const MovingInHeadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovingInHeadCubit(),
      child: const MovingInHeadView(),
    );
  }
}

class MovingInHeadView extends StatelessWidget {
  const MovingInHeadView({super.key});

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
          'Переміщення на склад',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
        child: Column(
          children: [
            const _TableHead(),
            BlocConsumer<MovingInHeadCubit, MovingInHeadState>(
              listener: (context, state) {
                if (state.status.isNotFound) {
                  Alerts(msg: state.errorMassage, context: context).showError();
                }
              },
              builder: (context, state) {
                if (state.status.isInitial) {
                  context.read<MovingInHeadCubit>().getOrders();
                }
                if (state.status.isLoading) {
                  return const Expanded(
                      child: Center(child: CircularProgressIndicator()));
                }
                if (state.status.isFailure) {
                  return Expanded(
                    child: WentWrong(
                      onPressed: () =>
                          context.read<MovingInHeadCubit>().getOrders(),
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
                context.read<MovingInHeadCubit>().getOrders();
              })
        ],
      ),
    );
  }
}

class _CustomTable extends StatelessWidget {
  const _CustomTable({required this.orders});

  final MovingInOrders orders;

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
                textStyle: theme.textTheme.titleSmall!.copyWith(fontSize: 12),
              ),
              RowElement(
                  flex: 4,
                  value: order.date,
                  textStyle: theme.textTheme.titleSmall),
            ],
            index: index,
            onTap: () {
              if (orders.orders[index].invoice == '0') {
                showStartReceivingDialog(context, orders.orders[index]);
              } else {
                Navigator.pushNamed(context, AppRoutes.movingInDataPage,
                    arguments: {
                      'order': orders.orders[index],
                      'cubit': context.read<MovingInHeadCubit>()
                    });
              }
            },
            color: order.invoice != '0'
                ? myColors.tableYellow
                : index % 2 != 0
                    ? myColors.tableDarkColor
                    : myColors.tableLightColor,
          );

          // InkWell(
          //   onTap: () {
          //     if (orders.orders[index].invoice == '0') {
          //       showStartReceivingDialog(context, orders.orders[index]);
          //     } else {
          //       Navigator.pushNamed(context, AppRoutes.movingInDataPage,
          //           arguments: {
          //             'order': orders.orders[index],
          //             'cubit': context.read<MovingInHeadCubit>()
          //           });
          //     }
          //   },
          //   child: _CustomTableRow(
          //     index: index,
          //     lastIndex: orders.orders.length - 1,
          //     order: orders.orders[index],
          //   ),
          // );
        },
      ),
    );
  }
}

// class _CustomTableRow extends StatelessWidget {
//   const _CustomTableRow(
//       {required this.index, required this.lastIndex, required this.order});
//   final MovingInOrder order;
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
//           color: order.invoice != '0'
//               ? const Color.fromARGB(255, 255, 245, 151)
//               : index % 2 == 0
//                   ? Colors.grey[200]
//                   : Colors.white,
//           border: const Border.symmetric(
//               vertical: BorderSide(width: 1),
//               horizontal: BorderSide(width: 0.5)),
//           borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(lastIndex == index ? 15 : 0),
//               bottomRight: Radius.circular(lastIndex == index ? 15 : 0))),
//       child: Row(
//         children: [
//           RowElement(
//               flex: 1,
//               value: (index + 1).toString(),
//               textStyle: theme.textTheme.titleSmall),
//           RowElement(
//               flex: 3,
//               value: order.docId,
//               textStyle: theme.textTheme.titleSmall),
//           RowElement(
//             flex: 6,
//             value: order.customer,
//             textStyle: theme.textTheme.titleSmall!.copyWith(fontSize: 12),
//           ),
//           RowElement(
//               flex: 4,
//               value: order.date,
//               textStyle: theme.textTheme.titleSmall),
//         ],
//       ),
//     );
//   }
// }

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

showStartReceivingDialog(BuildContext context, MovingInOrder order) {
  showDialog(
    context: context,
    builder: (_) => BlocProvider.value(
      value: context.read<MovingInHeadCubit>(),
      child: StartReceivingDialog(
        order: order,
      ),
    ),
  );
}

class StartReceivingDialog extends StatelessWidget {
  const StartReceivingDialog({super.key, required this.order});
  final MovingInOrder order;

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
              Navigator.pushNamed(context, AppRoutes.movingInDataPage,
                  arguments: {
                    'order': order,
                    'cubit': context.read<MovingInHeadCubit>()
                  });
            },
            child: const Text(
              'Розпочати',
            ))
      ],
    );
  }
}
