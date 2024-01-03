import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/moving_in_data_cubit.dart';

class MovingInBarcodeInput extends StatefulWidget {
  const MovingInBarcodeInput({super.key,});


  @override
  State<MovingInBarcodeInput> createState() =>
      _MovingInBarcodeInputState();
}

class _MovingInBarcodeInputState extends State<MovingInBarcodeInput> {
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
          final String invoice = context.read<MovingInDataCubit>().state.noms.invoice;
          if (controller.text.isNotEmpty) {
            context
                .read<MovingInDataCubit>()
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
