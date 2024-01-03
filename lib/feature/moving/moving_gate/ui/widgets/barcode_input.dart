import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/moving/moving_gate/cubit/moving_gate_order_data_cubit.dart';
import 'package:virok_wms/feature/moving/moving_gate/ui/widgets/dialog/nom_scan.dart';
import 'package:virok_wms/models/noms_model.dart';

class MovingBarcodeInput extends StatefulWidget {
  const MovingBarcodeInput({super.key, required this.docId});

  final String docId;

  @override
  State<MovingBarcodeInput> createState() => _MovingBarcodeInputState();
}

class _MovingBarcodeInputState extends State<MovingBarcodeInput> {
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
            context.read<MovingGateOrderDataCubit>().getNoms(widget.docId);
            final Nom nom =
                context.read<MovingGateOrderDataCubit>().search(value);
            if (nom != Nom.empty) {
              showNomInput(context, nom.codeCell, widget.docId,
                  nom.barcode.first.barcode, nom);
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
