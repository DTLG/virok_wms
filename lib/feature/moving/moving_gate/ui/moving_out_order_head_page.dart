import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/route/app_routes.dart';
import 'package:virok_wms/models/order.dart';

import 'package:virok_wms/ui/widgets/widgets.dart';

import '../../../../ui/theme/theme.dart';
import '../cubit/moving_gate_order_head_cubit.dart';

final AudioPlayer _audioPlayer = AudioPlayer();

class MovingGateHeadPage extends StatelessWidget {
  const MovingGateHeadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovingGateOrdersHeadCubit(),
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
          'Переміщення біля воріт',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
        child: Column(
          children: [
            const _TableHead(),
            BlocConsumer<MovingGateOrdersHeadCubit, MovingGateOrdersHeadState>(
              listener: (context, state) {
                if (state.status.isNotFound) {
                  Alerts(msg: state.errorMassage, context: context).showError();
                }
              },
              builder: (context, state) {
                if (state.status.isInitial) {
                  context.read<MovingGateOrdersHeadCubit>().getOrders();
                  return const Expanded(
                      child: Center(child: CircularProgressIndicator()));
                }
                if (state.status.isLoading) {
                  return const Expanded(
                      child: Center(child: CircularProgressIndicator()));
                }
                if (state.status.isFailure) {
                  () async {
                    await _audioPlayer
                        .play(AssetSource('sounds/error_sound.mp3'));
                  };
                  return Expanded(
                    child: WentWrong(
                      onPressed: () =>
                          context.read<MovingGateOrdersHeadCubit>().getOrders(),
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
                context.read<MovingGateOrdersHeadCubit>().getOrders();
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
              Navigator.pushNamed(context, AppRoutes.movingGateDataPage,
                  arguments: {
                    'docId': orders.orders[index].docId,
                    'cubit': context.read<MovingGateOrdersHeadCubit>()
                  });
            },
            color: index % 2 != 0
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
