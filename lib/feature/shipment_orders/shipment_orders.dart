import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/shipment_orders/cubit/order_head_cubit.dart';

import '../../ui/widgets/went_wrong.dart';
import '../selection/ui/widgets/widgets.dart';
import 'shipment_orders_repository/models/orders.dart';

class ShipmentOrdersPage extends StatelessWidget {
  const ShipmentOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ShipmentHeadCubit(),
        child: BlocListener<ShipmentHeadCubit, ShipmentHeadState>(
          listener: (context, state) {
            SystemChannels.textInput.invokeMethod('TextInput.hide');
          },
          child: const ShipmentOrdersView(),
        ));
  }
}

class ShipmentOrdersView extends StatelessWidget {
  const ShipmentOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Відгрузка по замовленнях'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            _SearchField(),
            SizedBox(
              height: 8,
            ),
            _TableHead(),
            _CustomTable()
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatefulWidget {
  const _SearchField({super.key});

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onSubmitted: (barcode) {
        controller.clear();
        focusNode.requestFocus();
      },
      decoration: const InputDecoration(
          hintText: "Пошук...", prefixIcon: Icon(Icons.search)),
    );
  }
}

class _CustomTable extends StatelessWidget {
  const _CustomTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipmentHeadCubit, ShipmentHeadState>(
      builder: (context, state) {
        if (state.status.isInitial) {
          context.read<ShipmentHeadCubit>().getOrders();
        }
        if (state.status.isSuccess) {
          return Expanded(
            child: ListView.builder(
              itemCount: state.orders!.orders.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/shipment_orders/data',
                        arguments: state.orders?.orders[index]);
                  },
                  child: _CustomTableRow(
                    index: index,
                    lastIndex: state.orders!.orders.length - 1,
                    order: state.orders!.orders[index],
                  ),
                );
              },
            ),
          );
        }

        if (state.status.isFailure) {
          return WentWrong(
            onPressed: () {
              context.read<ShipmentHeadCubit>().getOrders();
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class _CustomTableRow extends StatelessWidget {
  const _CustomTableRow(
      {super.key,
      required this.index,
      required this.lastIndex,
      required this.order});
  final Order order;
  final int index;
  final int lastIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 45,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
          color: index % 2 == 0 ? Colors.grey[350] : Colors.white,
          border: const Border.symmetric(
              vertical: BorderSide(width: 1),
              horizontal: BorderSide(width: 0.5)),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(lastIndex == index ? 20 : 0),
              bottomRight: Radius.circular(lastIndex == index ? 20 : 0))),
      child: Row(
        children: [
          RowElement(
            flex: 2,
            value: (index + 1).toString(),
            textStyle: theme.textTheme.labelMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          RowElement(
            flex: 7,
            value: order.client,
            textStyle: theme.textTheme.labelMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          RowElement(
            flex: 4,
            value: order.docId,
            textStyle: theme.textTheme.labelMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          RowElement(
            flex: 4,
            value: order.date,
            textStyle: theme.textTheme.labelMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}



class _TableHead extends StatelessWidget {
  const _TableHead({super.key});

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
            flex: 2,
            value: "№",
            textStyle: theme.textTheme.labelMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          RowElement(
            flex: 7,
            value: "Клієнт",
            textStyle: theme.textTheme.labelMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          RowElement(
            flex: 4,
            value: "№ Документу",
            textStyle: theme.textTheme.labelMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          RowElement(
            flex: 4,
            value: "Дата",
            textStyle: theme.textTheme.labelMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
