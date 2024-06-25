import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/recharging/recharge/cubit/recharge_cubit.dart';
import 'package:virok_wms/ui/widgets/alerts.dart';
import 'package:virok_wms/ui/widgets/general_button.dart';
import 'package:virok_wms/ui/widgets/went_wrong.dart';

import 'widgets/table.dart';
import 'widgets/table_head.dart';

class RechargePage extends StatelessWidget {
  const RechargePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RechargeCubit(),
      child: const RechargeView(),
    );
  }
}

class RechargeView extends StatelessWidget {
  const RechargeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Підживлення',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<RechargeCubit>().getNoms();
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const RechargeTableHead(),
              BlocConsumer<RechargeCubit, RechargeState>(
                listener: (context, state) {
                  if (state.status.isNotFound) {
                    Alerts(msg: state.errorMassage, context: context)
                        .showError();
                  }
                },
                builder: (context, state) {
                  if (state.status.isInitial) {
                    context.read<RechargeCubit>().getNoms();
                    return const Expanded(
                        child: Center(child: CircularProgressIndicator()));
                  }
                  if (state.status.isLoading) {
                    return const Expanded(
                        child: Center(child: CircularProgressIndicator()));
                  }
                  if (state.status.isFailure) {
                    return Expanded(
                      child: Center(
                        child: WentWrong(
                          errorDescription: state.errorMassage,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    );
                  }
                  return RechargeTable(
                    noms: state.noms.tasks,
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
                context.read<RechargeCubit>().getNoms();
              })
        ],
      ),
    );
  }
}
