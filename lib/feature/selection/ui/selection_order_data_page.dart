import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;
import 'package:virok_wms/feature/selection/cubit/selection_order_data_cubit.dart';
import 'package:virok_wms/ui/widgets/alerts.dart';

import 'package:virok_wms/ui/widgets/widgets.dart';

import '../cubit/selection_order_head_cubit.dart';
import 'ui.dart';

class SelectionOrderDataPage extends StatelessWidget {
  const SelectionOrderDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectionOrderDataCubit(),
      child: const SelectionOrderDataView(),
    );
  }
}

class SelectionOrderDataView extends StatelessWidget {
  const SelectionOrderDataView({super.key});

  @override
  Widget build(BuildContext context) {
    // Якщо тип тзд мезонін тоді використовуємо docId і bascket, якщо ні то не використовуємо
    final argument =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final String docId = argument['docId'] ?? '';
    final SelectionOrdersHeadCubit selectionOrderHeadCubit = argument['cubit'];

    //----

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          docId,
          style: const TextStyle(fontSize: 16),
        ),
        leading: IconButton(
            onPressed: () {
              if (context.read<SelectionOrderDataCubit>().state.itsMezonine ==
                  true) {
                Navigator.pop(context);
                selectionOrderHeadCubit.getOrders();
              } else {
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        actions:  [AppBarButton(cubit: selectionOrderHeadCubit,)],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<SelectionOrderDataCubit>().getNoms(docId);
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [TableInfo(), BascketInfo()],
                  ),
                  const TableHead(),
                  BlocConsumer<SelectionOrderDataCubit,
                      SelectionOrderDataState>(
                    listener: (context, state) {
                      if (state.status.isNotFound) {
                        Alerts(msg: state.errorMassage, context: context)
                            .showError();
                      }
                    },
                    builder: (context, state) {
                      if (state.status.isInitial) {
                        context.read<SelectionOrderDataCubit>().getNoms(docId);
                      }
                      if (state.status.isLoading) {
                        return const Expanded(
                            child: Center(child: CircularProgressIndicator()));
                      }
                      if (state.status.isFailure) {
                        return WentWrong(
                          errorMassage: state.errorMassage,
                          onPressed: () => Navigator.pop(context),
                        );
                      }
                      return CustomTable(
                        noms: state.noms.noms,
                      );
                    },
                  ),
                ],
              ),
            ),
            Center(
              child: Transform.rotate(
                angle: -math.pi / 4,
                child: const Text(
                  'Мезонін',
                  style: TextStyle(
                      fontSize: 90,
                      color: Color.fromARGB(22, 17, 29, 57),
                      fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GeneralButton(
              lable: 'Оновити',
              onPressed: () {
                context.read<SelectionOrderDataCubit>().getNoms(docId);
              })
        ],
      ),
    );
  }
}

class TableInfo extends StatelessWidget {
  const TableInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<SelectionOrderDataCubit, SelectionOrderDataState>(
      buildWhen: (previous, current) => !current.status.isLoading,
      builder: (context, state) {
        if (state.status.isSuccess) {
          return Card(
              color: const Color.fromARGB(255, 219, 219, 219),
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 6),
              shape: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icons/table_icon.png',
                      width: 25,
                      height: 25,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      state.noms.noms.first.table,
                      style: theme.textTheme.titleLarge,
                    )
                  ],
                ),
              ));
        }
        return const SizedBox();
      },
    );
  }
}

class BascketInfo extends StatelessWidget {
  const BascketInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<SelectionOrderDataCubit, SelectionOrderDataState>(
      buildWhen: (previous, current) => !current.status.isLoading,
      builder: (context, state) {
        if (state.status.isSuccess) {
          return Card(
            color: const Color.fromARGB(255, 219, 219, 219),
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 6),
            shape: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/basket_icon.png',
                    width: 25,
                    height: 25,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    state.noms.noms.first.basckets.first.name,
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
