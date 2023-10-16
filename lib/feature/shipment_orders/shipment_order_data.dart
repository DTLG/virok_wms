import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/shipment_orders/cubit/order_data_cubit.dart';

import '../../models/noms_model.dart';
import '../../ui/widgets/alerts.dart';
import '../../ui/widgets/went_wrong.dart';
import 'shipment_orders_repository/models/orders.dart';

class ShipmentOrderDataPage extends StatelessWidget {
  const ShipmentOrderDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)!.settings.arguments as Order;

    return BlocProvider(
        create: (context) => ShipmentDataCubit(),
        child: BlocListener<ShipmentDataCubit, ShipmentDataState>(
          listener: (context, state) {
            SystemChannels.textInput.invokeMethod('TextInput.hide');
          },
          child: ShipmentOrderDataView(
            order: order,
          ),
        ));
  }
}

class ShipmentOrderDataView extends StatelessWidget {
  const ShipmentOrderDataView({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(order.client),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            BlocBuilder<ShipmentDataCubit, ShipmentDataState>(
              buildWhen: (previous, current) => false,
              builder: (context, state) {
                if (state.status.isInitial) {
                  context.read<ShipmentDataCubit>().getOrder(order.docId);
                }
                if (state.status.isSuccess) {
                  return const BarcodeInput();
                }
                return const TextField(
                  autofocus: true,
                  decoration: InputDecoration(hintText: "Відскануйте товар"),
                );
              },
            ),
            const SizedBox(
              height: 8,
            ),
            const TableHead(),
            const CustomTable(),
          ],
        ),
      ),
    );
  }
}

class BarcodeInput extends StatefulWidget {
  const BarcodeInput({super.key});

  @override
  State<BarcodeInput> createState() => _BarcodeInputState();
}

class _BarcodeInputState extends State<BarcodeInput> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: true,
      focusNode: focusNode,
      onSubmitted: (barcode) {
        // if (noms!.noms.isNotEmpty) {
        //   context.read<ShipmentDataCubit>().scanNoms(barcode, '1');
        // }
        controller.clear();
        focusNode.requestFocus();
      },
      decoration: const InputDecoration(
        hintText: "Відскануйте товар",
      ),
    );
  }
}

class CustomTable extends StatelessWidget {
  const CustomTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipmentDataCubit, ShipmentDataState>(
      builder: (context, state) {
        if (state.status.isSuccess) {
          return Expanded(
            child: ListView.builder(
              itemCount: state.noms?.noms.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return BlocProvider.value(
                              value: context.read<ShipmentDataCubit>(),
                              child: InputCountAlert(
                                onChanged: (value) {
                                  
                                },
                                  onPressed: () {}));
                        });
                  },
                  child: CustomTableRow(
                    index: index,
                    lastIndex: state.noms!.noms.length - 1,
                    nom: state.noms!.noms[index],
                  ),
                );
              },
            ),
          );
        }

        if (state.status.isFailure) {
          return const WentWrong(
              // onPressed: () {
              //   context.read<ShipmentDataCubit>().getOrder();
              // },
              );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class CustomTableRow extends StatelessWidget {
  const CustomTableRow(
      {super.key,
      required this.index,
      required this.lastIndex,
      required this.nom});
  final Nom nom;
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
            flex: 7,
            value: nom.name,
            textStyle: theme.textTheme.labelSmall
                ?.copyWith(letterSpacing: 0.5, overflow: TextOverflow.ellipsis),
          ),
          RowElement(
            flex: 4,
            value: nom.article,
            textStyle: theme.textTheme.labelMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          RowElement(
            flex: 2,
            value: nom.qty.toString(),
            textStyle: theme.textTheme.labelMedium,
          ),
          RowElement(
            flex: 2,
            value: nom.count.toString(),
            textStyle: theme.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}

Widget rowElement(int flex, dynamic value) {
  return Expanded(
      flex: flex,
      child: Text(
        value.toString(),
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12),
      ));
}

class RowElement extends StatelessWidget {
  const RowElement(
      {super.key, required this.flex, required this.value, this.textStyle});

  final int flex;
  final String value;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: flex,
        child: Text(
          value.toString(),
          maxLines: 3,
          textAlign: TextAlign.center,
          style: textStyle,
        ));
  }
}

class TableHead extends StatelessWidget {
  const TableHead({super.key});

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
            flex: 7,
            value: "Назва",
            textStyle: theme.textTheme.labelSmall
                ?.copyWith(letterSpacing: 0.5, overflow: TextOverflow.ellipsis),
          ),
          RowElement(
              flex: 4,
              value: "Артикул",
              textStyle: theme.textTheme.labelMedium),
          RowElement(
            flex: 2,
            value: "К-ть",
            textStyle: theme.textTheme.labelMedium,
          ),
          RowElement(
            flex: 2,
            value: "Скан.",
            textStyle: theme.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
