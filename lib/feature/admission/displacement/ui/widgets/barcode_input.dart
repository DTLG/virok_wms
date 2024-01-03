import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/displacement_order_data_cubit.dart';

class DisplacementBarcodeInput extends StatefulWidget {
  const DisplacementBarcodeInput({super.key,});


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
          final String invoice = context.read<DisplacementOrderDataCubit>().state.noms.invoice;
          if (controller.text.isNotEmpty) {
            context
                .read<DisplacementOrderDataCubit>()
                .scan(value,invoice, 0);
            controller.clear();
          }
          focusNode.requestFocus();
        },
        decoration: const InputDecoration(hintText: 'Відскануйте штрихкод'),
      ),
    );
  }
}
