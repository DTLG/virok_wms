import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/route/app_routes.dart';
import 'package:virok_wms/ui/ui.dart';

class CellGenerationPage extends StatelessWidget {
  const CellGenerationPage({super.key});

  Future<String?> _getCityPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('storage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Друк етикетки комірки'),
      ),
      body: FutureBuilder<String?>(
        future: _getCityPreference(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Помилка завантаження даних'));
          } else {
            final city = snapshot.data;

            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: GridButton(
                children: [
                  if (city == 'lviv' || city == null)
                    SquareButton(
                      lable: 'Львів',
                      color: const Color.fromRGBO(148, 39, 32, 1),
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.lvivCellsPage);
                      },
                    ),
                  if (city == 'kyiv' || city == null)
                    SquareButton(
                      lable: 'Київ',
                      color: const Color.fromRGBO(217, 219, 218, 1),
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.kyivCellsPage);
                      },
                    ),
                  if (city == 'harkiv' || city == null)
                    SquareButton(
                      lable: 'Харків',
                      color: const Color.fromRGBO(217, 219, 218, 1),
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.harkivCellsPage);
                      },
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
