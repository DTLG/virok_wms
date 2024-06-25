import 'package:flutter/material.dart';
import 'package:virok_wms/route/app_routes.dart';
import 'package:virok_wms/ui/theme/app_color.dart';

import '../../ui/widgets/widgets.dart';

class ReturningPage extends StatelessWidget {
  const ReturningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Повернення'),
        ),
        body: GridButton(
          children: [
            SquareButton(
              lable: 'Повернення на склад',
                      color: AppColors.lightGrey,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.returningInHeadPage);
              },
            ),
            SquareButton(
              lable: 'Повернення з складу',
                      color: AppColors.darkRed,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.returningOutHeadPage);
              },
            ),
                SquareButton(
              lable: 'Повернення мережі',
                      color: AppColors.darkRed,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.returnEpicPage);
              },
            )
          ],
        ));
  }
}
