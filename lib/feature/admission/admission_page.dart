import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/route/app_routes.dart';
import 'package:virok_wms/ui/theme/app_color.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';
import 'package:virok_wms/utils.dart';

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
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              final value = prefs.getString('storage') ?? 'lviv';

              if (context.mounted) {
                if (value.toStorage.isLviv) {
                  Navigator.pushNamed(
                      context, AppRoutes.admissionOlacementOrderHeadPage);
                  return;
                }
                if (value.toStorage.isHarkiv) {
                  Navigator.pushNamed(
                      context, AppRoutes.admissionOlacementOrderHeadPage);
                  return;
                }
                if (value.toStorage.isKyiv) {
                  showModal(
                    context: context,
                    builder: (context) => YesOrNoDialog(
                      noButton: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                            context, AppRoutes.placementFromReturnPage);
                      },
                      yesButton: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                            context, AppRoutes.placementFromAdmissionPage);
                      },
                      yesLable: 'З приймання',
                      noLable: 'З повернення',
                      buttonTextStyle: const TextStyle(fontSize: 15),
                    ),
                  );
                  return;
                }
              }
            },
          )
        ],
      ),
    );
  }
}
