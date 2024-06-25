import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/admission/kyiv_placement/placement_from_return/cubit/placement_cubit.dart';
import 'package:virok_wms/feature/admission/kyiv_placement/placement_from_return/ui/widgets/nom_scan_dialog.dart';
import 'package:virok_wms/feature/admission/placement/placement_repository/model/admission_nom.dart';
import 'package:virok_wms/feature/home_page/cubit/home_page_cubit.dart';
import 'package:virok_wms/ui/widgets/camera_scaner_button.dart';

class PlacementBarcodeInput extends StatefulWidget {
  const PlacementBarcodeInput({
    super.key,
  });

  @override
  State<PlacementBarcodeInput> createState() => _PlacementBarcodeInputState();
}

class _PlacementBarcodeInputState extends State<PlacementBarcodeInput> {
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
            final AdmissionNom nom =
                context.read<PlacementFromReturnCubit>().search(value);
            if (nom != AdmissionNom.empty) {
              showPlacementNomScanDialog(context, nom);
            }

            controller.clear();
          }
          focusNode.requestFocus();
        },
        decoration: InputDecoration(
            hintText: 'Відскануйте штрихкод',
            suffixIcon: cameraScaner
                ? CameraScanerButton(
                    scan: (value) {
                      Timer(const Duration(milliseconds: 1), () {
                        final AdmissionNom nom =
                            context.read<PlacementFromReturnCubit>().search(value);
                        if (nom != AdmissionNom.empty) {
                          showPlacementNomScanDialog(context, nom);
                        }
                      });
                    },
                  )
                : null),
      ),
    );
  }
}
