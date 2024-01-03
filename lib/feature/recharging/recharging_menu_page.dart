import 'package:flutter/material.dart';
import 'package:virok_wms/route/app_routes.dart';
import 'package:virok_wms/ui/theme/app_color.dart';

import '../../ui/widgets/widgets.dart';

class RechargingMenuPage extends StatelessWidget {
  const RechargingMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Підживлення'),
        ),
        body: GridButton(
          children: [
            SquareButton(
              lable: 'Підживлення',
                      color: AppColors.lightGrey,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.rechargePage);
              },
            ),
             SquareButton(
              lable: 'Переміщення між комірками',
                      color: AppColors.darkRed,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.movingInCells);
              },
            ) ,
  
          ],
        ));
  }
}
