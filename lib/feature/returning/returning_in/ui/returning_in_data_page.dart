import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:virok_wms/ui/widgets/widgets.dart';

import '../../../../ui/theme/app_color.dart';
import '../cubits/returning_in_data_cubit.dart';
import '../cubits/returning_in_head_cubit.dart';
import '../returning_in_repository/models/order.dart';
import 'widgets/barcode_input.dart';
import 'widgets/table.dart';
import 'widgets/table_head.dart';

class ReturningInDataPage extends StatelessWidget {
  const ReturningInDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReturningInDataCubit(),
      child: const ReturningInDataView(),
    );
  }
}

class ReturningInDataView extends StatelessWidget {
  const ReturningInDataView({super.key});

  @override
  Widget build(BuildContext context) {
    final argument =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final ReturningInOrder order = argument['order'];
    final ReturningInHeadCubit returningInHeadCubit = argument['cubit'];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          order.customer,
          style: const TextStyle(fontSize: 14),
        ),
        leading: IconButton(
            onPressed: () {
              returningInHeadCubit.getOrders();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        actions: [AppBarButton(order: order)],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ReturningInDataCubit>().getNoms(order);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReturningInBarcodeInput(
                order: order,
              ),
              const SizedBox(
                height: 8,
              ),
              const ReturningInTableHead(),
              BlocConsumer<ReturningInDataCubit, ReturningInDataState>(
                listener: (context, state) {
                  if (state.time.isFinite && state.status.isNotFound) {
                    Alerts(msg: state.errorMassage, context: context)
                        .showError();
                  }
                },
                builder: (context, state) {
                  if (state.status.isInitial) {
                    context.read<ReturningInDataCubit>().getNoms(order);
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
                        errorDescription: state.errorMassage,
                        onPressed: () => Navigator.pop(context),
                      ),
                    );
                  }
                  return ReturningInTable(
                    order: order,
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
          BlocBuilder<ReturningInDataCubit, ReturningInDataState>(
            builder: (context, state) {
              return GeneralButton(
                  lable: 'Завершити',
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) => BlocProvider.value(
                              value: context.read<ReturningInDataCubit>(),
                              child: AlertDialog(
                                content:
                                    const Text('Ви дійсно хочете завершити'),
                                actions: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: GeneralButton(
                                              lable: 'Так',
                                              onPressed: () {
                                                context
                                                    .read<
                                                        ReturningInDataCubit>()
                                                    .closeOrder(
                                                        state.noms.invoice);
                                                returningInHeadCubit
                                                    .getOrders();
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              })),
                                      Expanded(
                                        child: GeneralButton(
                                            lable: 'ні',
                                            onPressed: () {
                                              Navigator.pop(context);
                                            }),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ));
                    final int checkFullScan =
                        context.read<ReturningInDataCubit>().checkFullOrder();
                    if (checkFullScan == 0) {
                      Alerts(
                              msg: 'Завдання відскановано не повністю',
                              context: context)
                          .showError();
                    }
                  });
            },
          )
        ],
      ),
    );
  }
}

class AppBarButton extends StatelessWidget {
  const AppBarButton({super.key, required this.order});

  final ReturningInOrder order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: ElevatedButton(
        onPressed: () {
          context.read<ReturningInDataCubit>().getNoms(order);
        },
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(AppColors.darkBlue)),
        child: SizedBox(
            width: 75,
            child: Text(
              'Оновити',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall!.copyWith(color: Colors.white),
            )),
      ),
    );
  }
}

// showRequestToPlacementDialog(BuildContext context) {
  //   showDialog(
    //     context: context,
    //     builder: (context) => const RequestToPlacementDialog(),
  //   );
// }

// class RequestToPlacementDialog extends StatelessWidget {
  //   const RequestToPlacementDialog({super.key});

  //   @override
  //   Widget build(BuildContext context) {
    //     return AlertDialog(
      //       content: const Text(
        //         'Перейти до розміщення товарів',
        //         textAlign: TextAlign.center,
      //       ),
      //       actions: [
        //         ElevatedButton(
            //             onPressed: () {
              //               Navigator.pop(context);
            //             },
            //             child: const Text('Ні')),
        //         ElevatedButton(
            //             onPressed: () {
              //               Navigator.pop(context);
              //               Navigator.pop(context);
              //               Navigator.pop(context);

              //               Navigator.pushNamed(context, AppRoutes.placementPage);
            //             },
            //             child: const Text('Так'))
      //       ],
      //       actionsAlignment: MainAxisAlignment.spaceAround,
    //     );
  //   }
// }
