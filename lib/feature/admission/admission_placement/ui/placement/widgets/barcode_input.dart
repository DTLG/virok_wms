import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/admission/admission_placement/cubit/placement_cubit.dart';
import 'package:virok_wms/feature/admission/admission_placement/placement_repository/model/placement_nom.dart';
import 'package:virok_wms/feature/admission/admission_placement/ui/placement/widgets/widgets.dart';
import 'package:virok_wms/ui/widgets/alerts.dart';

class PlacementBarcodeInput extends StatefulWidget {
  const PlacementBarcodeInput({
    super.key,
  });

  @override
  State<PlacementBarcodeInput> createState() =>
      _PlacementBarcodeInputState();
}

class _PlacementBarcodeInputState extends State<PlacementBarcodeInput> {
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
            final PlacementNom nom =
                context.read<PlacementCubit>().search(value);
            if (nom != PlacementNom.empty) {
              
                            
 if (nom.freeCount!= 0) {
                showNomScanDialog(context, nom);
              }  else{
                Alerts(msg: 'Кількість доступного товару 0', context: context).showError();
              }
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
