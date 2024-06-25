import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:virok_wms/feature/admission/displacement/ui/widgets/dialog/count_input.dart';
import 'package:virok_wms/feature/home_page/cubit/home_page_cubit.dart';
import 'package:virok_wms/ui/widgets/camera_scaner_button.dart';

import '../../cubits/displacement_order_data_cubit.dart';
import '../../models/models.dart';

class DisplacementBarcodeInput extends StatefulWidget {
  const DisplacementBarcodeInput({super.key, required this.order});

  final DisplacementOrder order;

  @override
  State<DisplacementBarcodeInput> createState() =>
      _DisplacementBarcodeInputState();
}

class _DisplacementBarcodeInputState extends State<DisplacementBarcodeInput> {
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
                : const SizedBox()),
      ),
    );
  }

  void onSubmited(String value)  {
    final String invoice =
        context.read<DisplacementOrderDataCubit>().state.noms.invoice;
    context.read<DisplacementOrderDataCubit>().getNoms(widget.order);
    final DisplacementNom nom = 
        context.read<DisplacementOrderDataCubit>().scan(value);
    if (nom != DisplacementNom.empty) {
      showManualCountIncrementAlert(
          context, nom.barcodes.first.barcode, invoice, nom);
    }
    else{
      context.read<DisplacementOrderDataCubit>().addNom(value, invoice, 1);
    }
  }
}
