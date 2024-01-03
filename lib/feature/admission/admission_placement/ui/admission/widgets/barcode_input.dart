import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/admission/admission_placement/cubit/admission_placement_cubit.dart';
import 'package:virok_wms/feature/admission/admission_placement/placement_repository/model/admission_placement_nom.dart';
import 'package:virok_wms/feature/admission/admission_placement/ui/admission/widgets/nom_scan_dialog.dart';

class AdmissionBarcodeInput extends StatefulWidget {
  const AdmissionBarcodeInput({
    super.key,
  });

  @override
  State<AdmissionBarcodeInput> createState() =>
      _AdmissionBarcodeInputState();
}

class _AdmissionBarcodeInputState extends State<AdmissionBarcodeInput> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        autofocus: true,
        controller: controller,
        focusNode: focusNode,
        textAlignVertical: TextAlignVertical.bottom,
        onSubmitted: (value) {
          if (controller.text.isNotEmpty) {
            final AdmissionNom nom =
                context.read<AdmissionPlacementCubit>().search(value);
            if (nom != AdmissionNom.empty) {
              
              showNomScanDialog(context, nom);
            }

            controller.clear();
          }
          focusNode.requestFocus();
        },
        decoration: const InputDecoration(hintText: 'Відскануйте штрихкод'),
      ),
    );
  }
}
