import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/admission/kyiv_placement/placement_from_return/cubit/placement_cubit.dart';
import 'package:virok_wms/feature/admission/kyiv_placement/placement_from_return/ui/widgets/barcode_input.dart';
import 'package:virok_wms/feature/admission/kyiv_placement/placement_from_return/ui/widgets/widgets.dart';

import '../../../../../ui/ui.dart';



class PlacementFromReturnPage extends StatelessWidget {
  const PlacementFromReturnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlacementFromReturnCubit(),
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
        title:  const Text('Розміщення з повернення',
          style: TextStyle(fontSize: 16),
        ),
       
       
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<PlacementFromReturnCubit>().getNoms();
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
         const PlacementBarcodeInput(),
         const SizedBox(height: 5,),
              const PlacementTableHead(),
              BlocConsumer<PlacementFromReturnCubit,
                  PlacementFromRetrunState>(
                listener: (context, state) {
                  if (state.status.isNotFound) {
                    Alerts(msg: state.errorMassage, context: context)
                        .showError();
                  }
                },
                builder: (context, state) {
                  if (state.status.isInitial) {
          context.read<PlacementFromReturnCubit>().getNoms();
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
          context.read<PlacementFromReturnCubit>().getNoms();
              })
        ],
      ),
    );
  }
}
