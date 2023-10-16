import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/ui/widgets/row_element.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';

import '../cubit/order_head_cubit.dart';
import 'widgets/widgets.dart';

class SelectionOrderHeadPage extends StatelessWidget {
  const SelectionOrderHeadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectionOrderHeadCubit(),
      child: const OrderInvoiceHeadView(),
    );
  }
}

class OrderInvoiceHeadView extends StatelessWidget {
  const OrderInvoiceHeadView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Завдання на відбір'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            TableHead(
              rowElement: [
                RowElement(
                  flex: 1,
                  value: "№",
                  textStyle: theme.textTheme.labelSmall?.copyWith(
                      letterSpacing: 0.5, overflow: TextOverflow.ellipsis),
                ),
                RowElement(
                    flex: 4,
                    value: "Номер",
                    textStyle: theme.textTheme.labelMedium),
                RowElement(
                  flex: 4,
                  value: "Дата",
                  textStyle: theme.textTheme.labelMedium,
                ),
              ],
            ),
            BlocBuilder<SelectionOrderHeadCubit, SelectionOrderHeadState>(
              builder: (context, state) {
                if (state.status.isInitial) {
                  context.read<SelectionOrderHeadCubit>().getOrders();
                }
                if (state.status.isFailure) {
                  return WentWrong(
                    errorMassage: state.errorMassage,
                    onPressed: () =>
                        context.read<SelectionOrderHeadCubit>().getOrders(),
                  );
                }
                if (state.status.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return CustomTable(orders: state.orders.orders);
              },
            ),
          ],
        ),
      ),
    );
  }
}
