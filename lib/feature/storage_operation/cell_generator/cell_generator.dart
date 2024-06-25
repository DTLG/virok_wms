import 'package:flutter/material.dart';
import 'package:virok_wms/route/app_routes.dart';
import 'package:virok_wms/ui/ui.dart';

class CellGenerationPage extends StatelessWidget {
  const CellGenerationPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Друк етикетки комірки'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(3.0),
        child: GridButton(children: [
          SquareButton(
              lable: 'Львів',
              color: const Color.fromRGBO(148, 39, 32, 1),
              onTap: () {
                 Navigator.pushNamed(context, AppRoutes.lvivCellsPage);
              }),
          SquareButton(
              lable: "Київ",
              color: const Color.fromRGBO(217, 219, 218, 1),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.kyivCellsPage);
              })
        ]),
      ),
    );
  }
}
