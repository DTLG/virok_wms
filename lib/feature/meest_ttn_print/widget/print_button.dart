import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/meest_ttn_print/cubit/ttn_print_cubit.dart';

class PrintButton extends StatelessWidget {
  const PrintButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            if (context.read<TtnPrintCubit>().state.status !=
                TtnPrintStatus.failure) {
              var printValue = context.read<TtnPrintCubit>().state.printValue;
              context.read<TtnPrintCubit>().printSticker(printValue);
            }
          },
          child: const Text('Друк'),
        ),
      ),
    );
  }
}
