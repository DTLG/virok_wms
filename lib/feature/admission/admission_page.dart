import 'package:flutter/material.dart';
import 'package:virok_wms/route/app_routes.dart';
import 'package:virok_wms/ui/theme/app_color.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';

class AdmissionPage extends StatelessWidget {
  const AdmissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Поступлення'),
      ),
      body: GridButton(
        children: [
          SquareButton(
            lable: 'Прийом товару',
                      color: AppColors.lightGrey,
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.displacementOrderHeadPage);
            },
          ),
          SquareButton(
            lable: 'Розміщення товару',
                      color: AppColors.darkRed,
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.admissionOlacementOrderHeadPage);
            },
          )
        ],
      ),
    );
  }
}
