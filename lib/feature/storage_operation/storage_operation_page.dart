import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/storage_operation/cubit/storage_operations_cubit.dart';
import 'package:virok_wms/feature/storage_operation/ttn_print/ui/ttn_print_page.dart';

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
            body: Padding(
                padding: const EdgeInsets.all(3.0),
                child: GridButton(
                    children: buildButtons(
                        placementButton,
                        writingOffButton,
                        cellInfoButton,
                        basketInfoButton,
                        cellGenerationButton,
                        context))));
      },
    );
  }
}

List<Widget> buildButtons(
    placement, writingOff, cell, basket, lablePrint, context) {
  List<Map<String, String>> a = [];

  if (placement)
    a.add({
      'name': 'ВНЕСЕННЯ ЗАЛИШКУ',
      'path': 'placement',
      'icon_path': "placement"
    });
  if (writingOff)
    a.add({
      'name': 'СПИСАННЯ ТОВАРІВ',
      'path': 'writing_off',
      'icon_path': "writing_off"
    });
  if (cell) a.add({'name': 'КОМІРКА', 'path': 'cell', 'icon_path': "cell"});
  if (basket)
    a.add({'name': 'КОРЗИНА', 'path': 'basket', 'icon_path': "basket"});
  if (lablePrint)
    a.add({
      'name': 'ДРУК ЕТИКЕТКИ КОМІРКИ',
      'path': 'lable_print',
      'icon_path': "lable_print"
    });
  a.add({
    'name': 'ПЕРЕВІРКА НОМЕНКЛАТУРИ',
    'path': 'check_nom',
    'icon_path': "check_nom"
  });
  a.add({
    'name': 'ДРУК ЕТИКЕТКИ ПРОДУКТУ',
    'path': 'product_lable_print',
    'icon_path': "lable_print"
  });
  a.add({
    'name': 'ДРУК ТТН',
    'path': 'ttn_page',
    'icon_path': "lable_print",
  });

  List<Widget> buttons = [];

  for (var i = 0; i < a.length; i++) {
    buttons.add(SquareButton(
      lable: a[i]['name'].toString(),
      color: i.buttonColor == 'r'
          ? const Color.fromRGBO(148, 39, 32, 1)
          : const Color.fromRGBO(217, 219, 218, 1),
      imagePath: 'assets/image/${a[i]['icon_path']}_${i.buttonColor}.png',
      lableWidth: 180,
      onTap: () {
        Navigator.pushNamed(context, a[i]['path'].toString().toAppRoutes);
      },
    ));
  }

  return buttons;
}

extension on String {
  get toAppRoutes {
    switch (this) {
      case 'placement':
        return AppRoutes.placementGoodsPage;
      case 'writing_off':
        return AppRoutes.writingOff;
      case 'cell':
        return AppRoutes.checkCell;
      case 'basket':
        return AppRoutes.checkBasket;
      case 'lable_print':
        return AppRoutes.cellGeneratorPage;
      case 'product_lable_print':
        return AppRoutes.productLablePrint;
      case 'check_nom':
        return AppRoutes.checkNomListPage;
      case 'ttn_page':
        return AppRoutes.ttnPage;
    }
  }
}
