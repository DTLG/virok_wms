import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/admission/placement/cubit/placement_orders_cubit.dart';
import 'package:virok_wms/feature/admission/placement/placement_repository/model/placement_order.dart';
import 'package:virok_wms/route/app_routes.dart';

import 'package:virok_wms/ui/widgets/widgets.dart';

import '../../../../ui/theme/theme.dart';

class PlacementOrdersHeadPage extends StatelessWidget {
  const PlacementOrdersHeadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlacementOrdersCubit(),
      child: const PlacenebtOrdersHeadView(),
    );
  }
}

class PlacenebtOrdersHeadView extends StatelessWidget {
  const PlacenebtOrdersHeadView({super.key});

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
          'Розміщення товарів',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
        child: Column(
          children: [
            const _TableHead(),
            BlocConsumer<PlacementOrdersCubit, PlacementOrderState>(
              listener: (context, state) {
                if (state.status.isNotFound) {
                  Alerts(msg: state.errorMassage, context: context).showError();
                }
              },
              builder: (context, state) {
                if (state.status.isInitial) {
                  context.read<PlacementOrdersCubit>().getOrders();
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
                      onPressed: () =>
                          context.read<PlacementOrdersCubit>().getOrders(),
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
                context.read<PlacementOrdersCubit>().getOrders();
              })
        ],
      ),
    );
  }
}

class _CustomTable extends StatelessWidget {
  const _CustomTable({required this.orders});

  final PlacementOrders orders;

  @override
  Widget build(BuildContext context) {
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
                  value: orders.orders[index].incomingInvoice,
                  textStyle: theme.textTheme.titleSmall),
              RowElement(
                  flex: 4,
                  value: orders.orders[index].date,
                  textStyle: theme.textTheme.titleSmall),
            ],
            index: index,
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.placementPage,
                arguments: {
                  "order":orders.orders[index],
                  "cubit":context.read<PlacementOrdersCubit>()
                }
              );
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
    ]);
  }
}
