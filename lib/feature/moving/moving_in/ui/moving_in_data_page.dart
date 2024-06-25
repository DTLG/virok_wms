import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:virok_wms/route/route.dart';

import 'package:virok_wms/ui/widgets/widgets.dart';

import '../../../../ui/theme/app_color.dart';
import '../cubits/moving_in_data_cubit.dart';
import '../cubits/moving_in_head_cubit.dart';
import '../moving_in_repository/models/order.dart';
import 'widgets/barcode_input.dart';
import 'widgets/table.dart';
import 'widgets/table_head.dart';

class MovingInDataPage extends StatelessWidget {
  const MovingInDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovingInDataCubit(),
      child: const MovingInDataView(),
    );
  }
}

class MovingInDataView extends StatelessWidget {
  const MovingInDataView({super.key});

  @override
  Widget build(BuildContext context) {
    final argument =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final MovingInOrder order = argument['order'];
    final MovingInHeadCubit movingInHeadCubit = argument['cubit'];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          order.customer,
          style: const TextStyle(fontSize: 14),
        ),
        leading: IconButton(
            onPressed: () {
              movingInHeadCubit.getOrders();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        actions: const [AppBarButton()],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<MovingInDataCubit>().getNoms(order);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MovingInBarcodeInput(),
              const SizedBox(
                height: 8,
              ),
              const MovingInTableHead(),
              BlocConsumer<MovingInDataCubit, MovingInDataState>(
                listener: (context, state) {
                  if (state.time.isFinite && state.status.isNotFound) {
                    Alerts(msg: state.errorMassage, context: context)
                        .showError();
                  }
                },
                builder: (context, state) {
                  if (state.status.isInitial) {
                    context.read<MovingInDataCubit>().getNoms(order);
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
                  return MovingInTable(
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
                context.read<MovingInDataCubit>().getNoms(order);
              })
        ],
      ),
    );
  }
}

class AppBarButton extends StatelessWidget {
  const AppBarButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final invoice =
        context.select((MovingInDataCubit cubit) => cubit.state.noms.invoice);
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: ElevatedButton(
        onPressed: () {
          final int checkFullScan =
              context.read<MovingInDataCubit>().checkFullOrder();

          if (checkFullScan == 0) {
            Alerts(msg: 'Не відскановано жодного товару', context: context)
                .showError();
          } else {
            context.read<MovingInDataCubit>().closeOrder(invoice);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.movingInHeadPage);

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

              Navigator.pushNamed(context, AppRoutes.placementPage);
            },
            child: const Text('Так'))
      ],
      actionsAlignment: MainAxisAlignment.spaceAround,
    );
  }
}
