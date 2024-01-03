import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/storage_operation/cubit/storage_operations_cubit.dart';

import '../../route/route.dart';
import '../../ui/widgets/widgets.dart';

class StorageOperationPage extends StatelessWidget {
  const StorageOperationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StorageOperationsCubit(),
      child: const StorageOperationView(),
    );
  }
}

class StorageOperationView extends StatelessWidget {
  const StorageOperationView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.select((StorageOperationsCubit cubit) => cubit.state);

    final bool cellInfoButton = state.cellInfoButton;
    final bool basketInfoButton = state.basketInfoButton;
    final bool cellGenerationButton = state.cellGeneratorButton;
    final bool placementButton = state.placementButton;
    final bool writingOffButton = state.writingOffButton;

    return BlocBuilder<StorageOperationsCubit, StorageOperationsState>(
      builder: (context, state) {
        context.read<StorageOperationsCubit>().getActivButton();
        return Scaffold(
          appBar: AppBar(
            title: const Text('Складські операції'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                placementButton
                    ? GeneralButton(
                        lable: 'Розміщення товарів',
                        onPressed: () {
                          Navigator.pushNamed(
                              context, AppRoutes.placementGoodsPage);
                        })
                    : const SizedBox(),
                writingOffButton
                    ? GeneralButton(
                        lable: 'Списання',
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.writingOff);
                        })
                    : const SizedBox(),
                cellInfoButton
                    ? GeneralButton(
                        lable: 'Комірка',
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.checkCell);
                        })
                    : const SizedBox(),
                // genBarButton
                //     ? GeneralButton(
                //         lable: 'Генерація штрихкоду',
                //         onPressed: () {
                //           Navigator.pushNamed(
                //               context, AppRoutes.barcodeGeneration);
                //         })
                //     : const SizedBox(),
                // barcodeLablePrintButton
                //     ? GeneralButton(
                //         lable: 'Друк етикетки',
                //         onPressed: () {
                //           Navigator.pushNamed(
                //               context, AppRoutes.barcodeLablePrint);
                //         })
                //     : const SizedBox(),
                basketInfoButton
                    ? GeneralButton(
                        lable: 'Кошик',
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.checkBasket);
                        })
                    : const SizedBox(),
                cellGenerationButton
                    ? GeneralButton(
                        lable: 'Друк етикетки комірки',
                        onPressed: () {
                          Navigator.pushNamed(
                              context, AppRoutes.cellGeneratorPage);
                        })
                    : const SizedBox(),
                GeneralButton(
                    lable: 'Перевірка номенклатури',
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.checkNomListPage);
                    })
              ],
            ),
          ),
        );
      },
    );
  }
}
