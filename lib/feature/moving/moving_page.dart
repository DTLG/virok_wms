
import 'package:flutter/material.dart';
import 'package:virok_wms/route/app_routes.dart';

import '../../ui/widgets/general_button.dart';

class MovingPage extends StatelessWidget {
  const MovingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Поступлення'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GeneralButton(
                lable: 'Переміщення на склад',
                onPressed: () {
                  Navigator.pushNamed(context,AppRoutes.movingInHeadPage);
                }),
            GeneralButton(
                lable: 'Переміщення з складу',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.movingOutHeadPage);
                })
          ],
        ),
      ),
    );
  }
}
