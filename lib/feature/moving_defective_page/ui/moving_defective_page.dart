import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/moving_defective_page/cubit/read_cubit/moving_defective_cubit.dart';
import 'package:virok_wms/route/app_routes.dart';
import 'package:virok_wms/ui/theme/app_theme.dart';
import 'package:virok_wms/ui/ui.dart';
import 'package:virok_wms/ui/widgets/row_element.dart';
import 'package:virok_wms/ui/widgets/table_widgets/table_body_element.dart';
import 'package:virok_wms/ui/widgets/table_widgets/table_head.dart';

class MovingDefectivePage extends StatelessWidget {
  const MovingDefectivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovingDefectiveCubit(),
      child: MovingDefectiveView(),
    );
  }
}

class MovingDefectiveView extends StatelessWidget {
  const MovingDefectiveView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Переміщення браку'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
        child: GridButton(
          children: [
            SquareButton(
              lable: 'Створення',
              color: const Color.fromRGBO(148, 39, 32, 1),
              onTap: () {
                Navigator.pushNamed(
                    context, 'moving_defective_create'.toAppRoutes);
              },
            ),
            SquareButton(
              lable: 'Прийом',
              color: const Color.fromRGBO(217, 219, 218, 1),
              onTap: () {
                Navigator.pushNamed(
                    context, 'moving_defective_read'.toAppRoutes);
              },
            ),
          ],
        ),
      ),
    );
  }
}

extension on String {
  get toAppRoutes {
    switch (this) {
      case 'moving_defective_read':
        return AppRoutes.movingdefectiveRead;
      case 'moving_defective_create':
        return AppRoutes.movingdefectiveCreate;
    }
  }
}
