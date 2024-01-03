import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/admission/displacement/displacement_repository/models/noms_model.dart';
import 'package:virok_wms/feature/admission/displacement/displacement_repository/models/order.dart';
import 'package:virok_wms/feature/admission/displacement/ui/widgets/dialog/count_input.dart';

import '../../cubits/displacement_order_data_cubit.dart';

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
    return SizedBox(
      height: 50,
      child: TextField(
        autofocus: true,
        controller: controller,
        focusNode: focusNode,
        textAlignVertical: TextAlignVertical.bottom,
        onSubmitted: (value) {
          final String invoice =
              context.read<DisplacementOrderDataCubit>().state.noms.invoice;
          if (controller.text.isNotEmpty) {
            context.read<DisplacementOrderDataCubit>().getNoms(widget.order);
            final DisplacementNom nom =
                context.read<DisplacementOrderDataCubit>().scan(value);
            if (nom != DisplacementNom.empty) {
              showManualCountIncrementAlert(
                  context, nom.barcode.first.barcode, invoice, nom);
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
