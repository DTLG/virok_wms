import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:virok_wms/feature/home_page/cubit/home_page_cubit.dart';
import 'package:virok_wms/feature/returning/return_epic/cubit/return_epic_cubit.dart';
import 'package:virok_wms/feature/returning/return_epic/model/return_epic_nom.dart';
import 'package:virok_wms/ui/widgets/camera_scaner_button.dart';

import 'count_input.dart';

class ReturnEpicBarcodeInput extends StatefulWidget {
  const ReturnEpicBarcodeInput({
    super.key,
  });

  @override
  State<ReturnEpicBarcodeInput> createState() => _ReturnEpicBarcodeInputState();
}

class _ReturnEpicBarcodeInputState extends State<ReturnEpicBarcodeInput> {
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
          if (controller.text.isNotEmpty) {
            onSubmited(value);
            controller.clear();
          }
          focusNode.requestFocus();
        },
        decoration: InputDecoration(
            hintText: 'Відскануйте штрихкод',
            suffixIcon: cameraScaner
                ? CameraScanerButton(scan: (value) {
                    Timer(const Duration(milliseconds: 1), () {
                      onSubmited(value);
                    });
                  })
                : null),
      ),
    );
  }

  void onSubmited(String value) {
    context.read<ReturnEpicCubit>().getNoms();
    final ReturnEpicNom nom = context.read<ReturnEpicCubit>().search(value);
    if (nom != ReturnEpicNom.empty) {
      manualCountIncrementDialog(context, value, nom);
    } else {
      // context.read<ReturnEpicCubit>().addNom(value, invoice, 1);
    }
  }
}
