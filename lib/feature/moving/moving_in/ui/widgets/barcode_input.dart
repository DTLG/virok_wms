import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/home_page/cubit/home_page_cubit.dart';
import 'package:virok_wms/feature/moving/moving_in/moving_in_repository/models/noms_model.dart';
import 'package:virok_wms/feature/moving/moving_in/ui/widgets/dialog/count_input.dart';
import 'package:virok_wms/ui/widgets/camera_scaner_button.dart';

import '../../cubits/moving_in_data_cubit.dart';

class MovingInBarcodeInput extends StatefulWidget {
  const MovingInBarcodeInput({super.key});

  @override
  State<MovingInBarcodeInput> createState() => _MovingInBarcodeInputState();
}

class _MovingInBarcodeInputState extends State<MovingInBarcodeInput> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final bool cameraScaner = context.read<HomePageCubit>().state.cameraScaner;

    return SizedBox(
      height: 50,
      child: TextField(
        autofocus: cameraScaner ? false : true,
        controller: controller,
        focusNode: focusNode,
        textAlignVertical: TextAlignVertical.bottom,
        onSubmitted: (value) {
          final nom = context.read<MovingInDataCubit>().search(value);
          final String invoice =
              context.read<MovingInDataCubit>().state.noms.invoice;
          if (nom != MovingInNom.empty) {
            showManualCountIncrementAlert(context, nom, invoice);
          } else {
            context.read<MovingInDataCubit>().scan(value, invoice, 1);
          }
          controller.clear();
          focusNode.requestFocus();

          // final String invoice =
          //     context.read<MovingInDataCubit>().state.noms.invoice;
          // if (controller.text.isNotEmpty) {
          // context.read<MovingInDataCubit>().scan(value, invoice, 0);
          //   controller.clear();
          // }
          // focusNode.requestFocus();
        },
        decoration: InputDecoration(
            hintText: 'Відскануйте штрихкод',
            suffixIcon: cameraScaner
                ? CameraScanerButton(
                    scan: (value) {
                      final String invoice =
                          context.read<MovingInDataCubit>().state.noms.invoice;

                      context.read<MovingInDataCubit>().scan(value, invoice, 0);
                    },
                  )
                : null),
      ),
    );
  }
}
