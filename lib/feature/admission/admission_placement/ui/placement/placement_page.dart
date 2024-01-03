import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/admission/admission_placement/cubit/placement_cubit.dart';
import 'package:virok_wms/route/app_routes.dart';
import 'package:virok_wms/ui/widgets/alerts.dart';

import '../../../../../ui/widgets/general_button.dart';
import '../../../../../ui/widgets/went_wrong.dart';
import 'widgets/widgets.dart';

class PlacementPage extends StatelessWidget {
  const PlacementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlacementCubit(),
      child: const PlacementView(),
    );
  }
}

class PlacementView extends StatelessWidget {
  const PlacementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Прийняті товари',
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
              const PlacementBarcodeInput(),
              const SizedBox(
                height: 8,
              ),
              const PlacementTableHead(),
              BlocConsumer<PlacementCubit, PlacementState>(
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
          Expanded(
            child: GeneralButton(
                lable: 'Розмістити все',
                onPressed: () async {
                  await context
                      .read<PlacementCubit>()
                      .createAllAdmisionPlacement()
                      .whenComplete(() => Navigator.pushNamed(
                          context, AppRoutes.admissionPlacementPage));
                }),
          ),
          Expanded(
            child: GeneralButton(
                lable: 'Перейти до розміщення',
                onPressed: () {
                  Navigator.pushNamed(
                      context, AppRoutes.admissionPlacementPage);
                }),
          )
        ],
      ),
    );
  }
}
