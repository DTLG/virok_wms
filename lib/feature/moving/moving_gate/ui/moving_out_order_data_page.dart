import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/ui/widgets/sound_interface.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';
import '../cubit/moving_gate_order_data_cubit.dart';
import '../cubit/moving_gate_order_head_cubit.dart';
import 'ui.dart';

final SoundInterface _soundInterface = SoundInterface();

class MovingGateDataPage extends StatelessWidget {
  const MovingGateDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NomsPageCubit(),
      child: const MovingOutOrderDataView(),
    );
  }
}

class MovingOutOrderDataView extends StatelessWidget {
  const MovingOutOrderDataView({super.key});

  @override
  Widget build(BuildContext context) {
    // Якщо тип тзд мезонін тоді використовуємо docId і bascket, якщо ні то не використовуємо
    final argument =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final String docId = argument['docId'] ?? '';
    final MovingGateOrdersHeadCubit movingOrderHeadCubit = argument['cubit'];
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
              movingOrderHeadCubit.getOrders();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        actions: [
          AppBarButton(
            title: 'Завершити',
            onPressed: () {
              final int checkFullScan =
                  context.read<NomsPageCubit>().checkFullOrder();

              if (checkFullScan == 0) {
                showDialog(
                    context: context,
                    builder: (_) => BlocProvider.value(
                          value: context.read<NomsPageCubit>(),
                          child: CheckFullScanDialog(
                            cubit: movingOrderHeadCubit,
                            docId: docId,
                          ),
                        ));
              } else {
                context
                    .read<NomsPageCubit>()
                    .closeOrder(docId, movingOrderHeadCubit)
                    .whenComplete(() {
                  movingOrderHeadCubit.getOrders();
                  Navigator.pop(context);
                });
              }
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<NomsPageCubit>().getNoms(docId);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MovingBarcodeInput(
                docId: docId,
              ),
              const SizedBox(
                height: 5,
              ),
              const TableHead(),
              BlocConsumer<NomsPageCubit, MovingGateOrderDataState>(
                listener: (context, state) {
                  if (state.status.isNotFound) {
                    Alerts(msg: state.errorMassage, context: context)
                        .showError();
                  }
                },
                builder: (context, state) {
                  if (state.status.isInitial) {
                    context.read<NomsPageCubit>().getNoms(docId);
                  }
                  if (state.status.isLoading) {
                    return const Expanded(
                        child: Center(child: CircularProgressIndicator()));
                  }
                  if (state.status.isFailure) {
                    () async {
                      _soundInterface.play(Event.error);
                    };
                    return Expanded(
                      child: WentWrong(
                        errorDescription: state.errorMassage,
                        onPressed: () => Navigator.pop(context),
                      ),
                    );
                  }
                  return CustomTable(
                    noms: state.noms.noms,
                    docId: docId,
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
                context.read<NomsPageCubit>().getNoms(docId);
              })
        ],
      ),
    );
  }
}
