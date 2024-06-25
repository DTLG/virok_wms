import 'package:flutter/material.dart';
import 'package:virok_wms/route/app_routes.dart';
import 'package:virok_wms/ui/theme/app_color.dart';

import '../../ui/widgets/widgets.dart';

class MovingPage extends StatelessWidget {
  const MovingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Переміщення'),
        ),
        body: GridButton(
          children: [
            SquareButton(
              lable: 'Переміщення на склад',
                      color: AppColors.lightGrey,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.movingInHeadPage);
              },
            ),
             SquareButton(
              lable: 'Переміщення з складу',
                      color: AppColors.darkRed,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.movingOutHeadPage);
              },
            ) ,
            SquareButton(
              lable: 'Переміщення біля воріт',
                      color: AppColors.darkRed,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.movingGateHeadPage);
              },
            ),
            
          ],
        ));
  }
}
