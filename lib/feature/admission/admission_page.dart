import 'package:flutter/material.dart';
import 'package:virok_wms/route/app_routes.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';

class AdmissionPage extends StatelessWidget {
  const AdmissionPage({super.key});

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
                lable: 'Прийом товару',
                onPressed: () {
                  Navigator.pushNamed(context,AppRoutes.displacementOrderHeadPage);
                }),
            GeneralButton(
                lable: 'Розміщення товару',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.admissionPlacementPage);
                })
          ],
        ),
      ),
    );
  }
}
