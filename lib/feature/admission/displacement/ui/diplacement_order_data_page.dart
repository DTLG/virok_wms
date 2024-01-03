import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/admission/displacement/ui/widgets/table.dart';
import 'package:virok_wms/feature/admission/displacement/ui/widgets/table_head.dart';
import 'package:virok_wms/route/route.dart';

import 'package:virok_wms/ui/widgets/alerts.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';

import '../../../../ui/theme/app_color.dart';
import '../cubits/displacement_order_data_cubit.dart';
import '../cubits/displacement_order_head_cubit.dart';
import '../displacement_repository/models/order.dart';
import 'widgets/barcode_input.dart';

class DiplacementOrderDataPage extends StatelessWidget {
  const DiplacementOrderDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DisplacementOrderDataCubit(),
      child: const DiplacementOrderDataView(),
    );
  }
}

class DiplacementOrderDataView extends StatelessWidget {
  const DiplacementOrderDataView({super.key});

  @override
  Widget build(BuildContext context) {
    final argument =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final DisplacementOrder order = argument['order'];
    final DisplacementOrdersHeadCubit diplacementOrderHeadCubit =
        argument['cubit'];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          order.customer,
          style: const TextStyle(fontSize: 14),
        ),
        leading: IconButton(
            onPressed: () {
              diplacementOrderHeadCubit.getOrders();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        actions: [AppBarButton(invoice: order.invoice)],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<DisplacementOrderDataCubit>().getNoms(order);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DisplacementBarcodeInput(),
              const SizedBox(
                height: 8,
              ),
              const DisplacementTableHead(),
              BlocConsumer<DisplacementOrderDataCubit,
                  DiplacementOrderDataState>(
                listener: (context, state) {
                  if (state.time.isFinite && state.status.isNotFound) {
                    Alerts(msg: state.errorMassage, context: context)
                        .showError();
                  }
                },
                builder: (context, state) {
                  if (state.status.isInitial) {
                    context.read<DisplacementOrderDataCubit>().getNoms(order);
                  }
                  if (state.status.isLoading) {
                    return const Expanded(
                        child: Center(child: CircularProgressIndicator()));
                  }
                  if (state.status.isFailure) {
                    return Expanded(
                      child: WentWrong(
                        errorDescription: state.errorMassage,
                        onPressed: () => Navigator.pop(context),
                      ),
                    );
                  }
                  return DisplacementTable(
                    noms: state.noms,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GeneralButton(
              lable: 'Оновити',
              onPressed: () {
                context.read<DisplacementOrderDataCubit>().getNoms(order);
              })
        ],
      ),
    );
  }
}

class AppBarButton extends StatelessWidget {
  const AppBarButton({super.key, required this.invoice});

  final String invoice;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: ElevatedButton(
        onPressed: () {
          final int checkFullScan =
              context.read<DisplacementOrderDataCubit>().checkFullOrder();

          if (checkFullScan == 0) {
            Alerts(msg: 'Не відскановано жодного товару', context: context)
                .showError();
          } else {
            context.read<DisplacementOrderDataCubit>().closeOrder(invoice);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.admissionPlacementPage);

            // showRequestToPlacementDialog(context);
          }
        },
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(AppColors.darkBlue)),
        child: SizedBox(
            width: 75,
            child: Text(
              'Завершити',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall!.copyWith(color: Colors.white),
            )),
      ),
    );
  }
}

showRequestToPlacementDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const RequestToPlacementDialog(),
  );
}

class RequestToPlacementDialog extends StatelessWidget {
  const RequestToPlacementDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Text(
        'Перейти до розміщення товарів',
        textAlign: TextAlign.center,
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Ні')),
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);

              Navigator.pushNamed(context, AppRoutes.admissionPlacementPage);
            },
            child: const Text('Так'))
      ],
      actionsAlignment: MainAxisAlignment.spaceAround,
    );
  }
}
