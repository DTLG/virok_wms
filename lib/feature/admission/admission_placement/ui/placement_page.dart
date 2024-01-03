import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/admission/admission_placement/cubit/placement_cubit.dart';
import 'package:virok_wms/ui/widgets/alerts.dart';

import '../../../../ui/widgets/general_button.dart';
import '../../../../ui/widgets/went_wrong.dart';
import 'widgets/widgets.dart';

class AdmissingPlacementPage extends StatelessWidget {
  const AdmissingPlacementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlacementCubit(),
      child: const AdmissingPlacementView(),
    );
  }
}

class AdmissingPlacementView extends StatelessWidget {
  const AdmissingPlacementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Розміщення товарів',
          style: TextStyle(fontSize: 16),
        ),
       
       
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<PlacementCubit>().getNoms();
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
         
              const PlacementTableHead(),
              BlocConsumer<PlacementCubit,
                  PlacementState>(
                listener: (context, state) {
                  if (state.status.isNotFound) {
                    Alerts(msg: state.errorMassage, context: context)
                        .showError();
                  }
                },
                builder: (context, state) {
                  if (state.status.isInitial) {
                    context.read<PlacementCubit>().getNoms();
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
                  return PlacementTable(
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
                context.read<PlacementCubit>().getNoms();
              })
        ],
      ),
    );
  }
}
