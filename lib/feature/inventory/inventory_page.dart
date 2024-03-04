import 'package:flutter/material.dart';

import '../../route/route.dart';
import '../../ui/ui.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Інвентаризація'),
        ),
        body: GridButton(
          children: [
            SquareButton(
              lable: 'Повна інвентаризація',
              color: AppColors.lightGrey,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.fullInventoryHeadPage);
              },
            ),
            SquareButton(
              lable: 'Інвентаризація по комірках',
              color: AppColors.darkRed,
              onTap: () {
                Navigator.pushNamed(
                    context, AppRoutes.inventoryByCellsTasksPage);
              },
            ),
            SquareButton(
              lable: 'Інвентаризація номенклатури',
              color: AppColors.darkRed,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.inventoryByNomTasksPage);
              },
            ),

                SquareButton(
              lable: 'Вибіркова інвентаризація',
              color: AppColors.lightGrey,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.inventoryNomInCellTasksPage);
              },
            ),
          ],
        ));
  }
}
