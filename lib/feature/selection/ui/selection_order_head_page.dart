import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/home_page/cubit/home_page_cubit.dart';
import 'package:virok_wms/route/app_routes.dart';
import 'package:virok_wms/feature/selection/cubit/selection_order_head_cubit.dart';
import 'package:virok_wms/models/order.dart';
import 'package:virok_wms/ui/theme/theme.dart';

import 'package:virok_wms/ui/widgets/widgets.dart';

class SelectionOrdersHeadPage extends StatelessWidget {
  const SelectionOrdersHeadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectionOrdersHeadCubit(),
      child: const SelectionOrdersHeadView(),
    );
  }
}

class SelectionOrdersHeadView extends StatefulWidget {
  const SelectionOrdersHeadView({super.key});

  @override
  State<SelectionOrdersHeadView> createState() =>
      _SelectionOrdersHeadViewState();
}

class _SelectionOrdersHeadViewState extends State<SelectionOrdersHeadView> {
  late Timer _timer;
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              _timer.cancel();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        title: const Text(
          'Завдання на відбір',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
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
                  final refreshTime =
                      context.read<HomePageCubit>().state.refreshTime;

                  _timer =
                      Timer.periodic(Duration(seconds: refreshTime), (timer) {
                    context.read<SelectionOrdersHeadCubit>().getOrders();
                  });

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
                return _CustomTable(
                  orders: state.orders,
                );
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
                if (isSelected) return;
                isSelected = true;
                context.read<SelectionOrdersHeadCubit>().getOrders();
                Timer(const Duration(seconds: 1), () {
                  isSelected = false;
                });
              })
        ],
      ),
    );
  }
}

class _CustomTable extends StatelessWidget {
  const _CustomTable({required this.orders});

  final Orders orders;

  @override
  Widget build(BuildContext context) {
    final bool itsMezonine = context.read<HomePageCubit>().state.itsMezonine;
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
                  flex: 1,
                  value: (index + 1).toString(),
                  textStyle: theme.textTheme.titleSmall),
              RowElement(
                  flex: 4,
                  value: orders.orders[index].docId,
                  textStyle: theme.textTheme.titleSmall),
              RowElement(
                  flex: 4,
                  value: orders.orders[index].date,
                  textStyle: theme.textTheme.titleSmall),
              SizedBox(
                width: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (orders.orders[index].importanceMark == 1)
                      const Text(
                        '!',
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w900,
                            color: Color.fromARGB(255, 255, 6, 6)),
                      ),
                    if (orders.orders[index].mMark == 1)
                      const Text(
                        'M',
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w700,
                            color: Color.fromARGB(255, 6, 60, 255)),
                      ),
                    if (orders.orders[index].newPostMark == 1)
                      const Text(
                        'Н',
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w700,
                            color: Color.fromARGB(255, 255, 6, 6)),
                      ),
                  ],
                ),
              ),
            ],
            index: index,
            onTap: () {
              if (itsMezonine) {
                if (orders.orders[index].baskets.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (_) => BlocProvider.value(
                      value: context.read<SelectionOrdersHeadCubit>(),
                      child: SetBuscetDialog(
                        docId: orders.orders[index].docId,
                        itsMezonine: itsMezonine,
                      ),
                    ),
                  );
                } else {
                  Navigator.pushNamed(context, AppRoutes.selectionOrderDataPage,
                      arguments: {
                        'docId': orders.orders[index].docId,
                        'cubit': context.read<SelectionOrdersHeadCubit>(),
                        'basket': orders.orders[index].baskets.first.bascet,
                      });
                }
              } else {
                Navigator.pushNamed(context, AppRoutes.selectionOrderDataPage,
                    arguments: {
                      'docId': orders.orders[index].docId,
                      'cubit': context.read<SelectionOrdersHeadCubit>(),
                      'basket': '',
                    });
              }
            },
            color: orders.orders[index].fullOrder != 0
                ? myColors.tableGreen
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
    return TableHeads(children: [
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
      const SizedBox(
        width: 50,
      )
    ]);
  }
}

class SetBuscetDialog extends StatefulWidget {
  const SetBuscetDialog(
      {super.key, required this.docId, required this.itsMezonine});

  final String docId;
  final bool itsMezonine;

  @override
  State<SetBuscetDialog> createState() => _SetBuscetDialogState();
}

class _SetBuscetDialogState extends State<SetBuscetDialog> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final bool cameraScaner = context.read<HomePageCubit>().state.cameraScaner;

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
        decoration: InputDecoration(
            hintText: "Відскануйте кошик",
            suffixIcon: cameraScaner
                ? CameraScanerButton(scan: (value) {
                    controller.text = value;
                  })
                : const SizedBox()),
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
                  if (!context.mounted) return;
                  Navigator.pop(context);

                  Navigator.pushNamed(context, AppRoutes.selectionOrderDataPage,
                      arguments: {
                        'docId': widget.docId,
                        'cubit': context.read<SelectionOrdersHeadCubit>(),
                        'basket': controller.text,
                      });
                }
              }
            })
      ],
    );
  }
}
