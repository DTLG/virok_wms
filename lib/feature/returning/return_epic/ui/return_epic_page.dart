import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/returning/return_epic/cubit/return_epic_cubit.dart';

import '../../../../ui/ui.dart';
import 'widgets/widgets.dart';

class ReturnEpicPage extends StatelessWidget {
  const ReturnEpicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReturnEpicCubit(),
      child: const ReturnEpicview(),
    );
  }
}

class ReturnEpicview extends StatelessWidget {
  const ReturnEpicview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Повернення мережі',
          style: TextStyle(fontSize: 16),
        ),
        actions: [AppBarButton(title: 'Завершити', onPressed: () {
          context.read<ReturnEpicCubit>().closeOrder();
        },)],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ReturnEpicCubit>().getNoms();
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ReturnEpicBarcodeInput(),
              const SizedBox(
                height: 5,
              ),
              const ReturnEpicTableHead(),
              BlocConsumer<ReturnEpicCubit, ReturnEpicState>(
                listener: (context, state) {
                  if (state.status.isNotFound) {
                    Alerts(msg: state.errorMassage, context: context)
                        .showError();
                  }
                },
                builder: (context, state) {
                  if (state.status.isInitial) {
                    context.read<ReturnEpicCubit>().getNoms();
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
                  return ReturnEpicTable(
                    noms: state.noms.noms,
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
                context.read<ReturnEpicCubit>().getNoms();
              })
        ],
      ),
    );
  }
}
