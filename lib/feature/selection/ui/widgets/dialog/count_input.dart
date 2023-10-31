import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/selection/cubit/selection_order_data_cubit.dart';
import 'package:virok_wms/models/noms_model.dart';
import 'package:virok_wms/ui/widgets/alerts.dart';

void showCountAlert(
  BuildContext context,
  Nom nom,
) {
  showDialog(
      barrierColor: Color.fromARGB(149, 0, 0, 0),
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<SelectionOrderDataCubit>(),
          child: InputCountAlert(
            nom: nom,
            onChanged: (value) {
              if (value.split('').first == '-') {
                Alerts(context: context, msg: 'Введене відємне число')
                    .showError();
                value = '';
              } else {}
            },
          ),
        );
      });
}
