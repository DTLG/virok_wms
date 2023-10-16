import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/selection1/order_data/cubit/selection_order_data_cubit.dart';

import 'package:virok_wms/models/orders.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';

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
    final order = ModalRoute.of(context)!.settings.arguments as Order;
    return Scaffold(
      appBar: AppBar(
        title: Text(order.docId),
        actions: const [AppBarButton()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const ContainerInput(),
            const SizedBox(
              height: 8,
            ),
            const TableHead(),
            BlocBuilder<SelectionOrderDataCubit, SelectionOrderDataState>(
              builder: (context, state) {
                if (state.status.isInitial) {
                  context.read<SelectionOrderDataCubit>().getOrder(order.docId);
                }
                if (state.status.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.status.isFailure) {
                  return WentWrong(errorMassage: state.errorMassage,onPressed: ()=>Navigator.pop(context),);
                }
                return CustomTable(
                  noms: state.noms.noms,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
