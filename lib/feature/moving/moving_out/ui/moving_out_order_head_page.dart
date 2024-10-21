import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/home_page/cubit/home_page_cubit.dart';
import 'package:virok_wms/route/app_routes.dart';
import 'package:virok_wms/models/order.dart';
import 'package:virok_wms/ui/widgets/sound_interface.dart';

import 'package:virok_wms/ui/widgets/widgets.dart';

import '../../../../ui/theme/theme.dart';
import '../cubit/moving_out_order_head_cubit.dart';

final SoundInterface _soundInterface = SoundInterface();

class MovingOutHeadPage extends StatelessWidget {
  const MovingOutHeadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovingOutOrdersHeadCubit(),
      child: const MovingOutOrdersHeadView(),
    );
  }
}

class MovingOutOrdersHeadView extends StatelessWidget {
  const MovingOutOrdersHeadView({super.key});

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
          'Переміщення з складу',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
        child: Column(
          children: [
            const _TableHead(),
            BlocConsumer<MovingOutOrdersHeadCubit, MovingOutOrdersHeadState>(
              listener: (context, state) {
                if (state.status.isNotFound) {
                  Alerts(msg: state.errorMassage, context: context).showError();
                }
              },
              builder: (context, state) {
                if (state.status.isInitial) {
                  context.read<MovingOutOrdersHeadCubit>().getOrders();
                  return const Expanded(
                      child: Center(child: CircularProgressIndicator()));
                }
                if (state.status.isLoading) {
                  return const Expanded(
                      child: Center(child: CircularProgressIndicator()));
                }
                if (state.status.isFailure) {
                  _soundInterface.play(Event.error);

                  return Expanded(
                    child: WentWrong(
                      onPressed: () =>
                          context.read<MovingOutOrdersHeadCubit>().getOrders(),
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
                context.read<MovingOutOrdersHeadCubit>().getOrders();
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
          final order = orders.orders[index];
          return TableElement(
            dataLenght: orders.orders.length,
            rowElement: [
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
            index: index,
            onTap: () {
              if (itsMezonine) {
                if (orders.orders[index].baskets.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (_) => BlocProvider.value(
                      value: context.read<MovingOutOrdersHeadCubit>(),
                      child: SetBuscetDialog(
                        docId: orders.orders[index].docId,
                        itsMezonine: itsMezonine,
                      ),
                    ),
                  );
                } else {
                  Navigator.pushNamed(context, AppRoutes.movingOutDataPage,
                      arguments: {
                        'docId': orders.orders[index].docId,
                        'cubit': context.read<MovingOutOrdersHeadCubit>(),
                        'basket': orders.orders[index].baskets.first.bascet,
                      });
                }
              } else {
                Navigator.pushNamed(context, AppRoutes.movingOutDataPage,
                    arguments: {
                      'docId': orders.orders[index].docId,
                      'cubit': context.read<MovingOutOrdersHeadCubit>(),
                      'basket': '',
                    });
              }
            },
            color: order.fullOrder != 0
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
    return TableHeads(
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
    );
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
                    .read<MovingOutOrdersHeadCubit>()
                    .setBasketToOrder(controller.text, widget.docId);

                if (status == true) {
                  if (!mounted) return;
                  Navigator.pop(context);

                  Navigator.pushNamed(context, AppRoutes.movingOutDataPage,
                      arguments: {
                        'docId': widget.docId,
                        'cubit': context.read<MovingOutOrdersHeadCubit>(),
                        'basket': controller.text,
                        'itsMezonine': widget.itsMezonine
                      });
                }
              }
            })
      ],
    );
  }
}
