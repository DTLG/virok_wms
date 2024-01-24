import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/home_page/cubit/home_page_cubit.dart';
import 'package:virok_wms/feature/returning/returning_in/returning_in_repository/models/noms_model.dart';
import 'package:virok_wms/feature/returning/returning_in/returning_in_repository/models/order.dart';
import 'package:virok_wms/feature/returning/returning_in/ui/widgets/dialog/count_input.dart';
import 'package:virok_wms/ui/widgets/camera_scaner_button.dart';

import '../../cubits/returning_in_data_cubit.dart';

class ReturningInBarcodeInput extends StatefulWidget {
  const ReturningInBarcodeInput({super.key, required this.order});

  final ReturningInOrder order;

  @override
  State<ReturningInBarcodeInput> createState() =>
      _ReturningInBarcodeInputState();
}

class _ReturningInBarcodeInputState extends State<ReturningInBarcodeInput> {
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
          final String invoice =
              context.read<ReturningInDataCubit>().state.noms.invoice;
          if (controller.text.isNotEmpty) {
            context.read<ReturningInDataCubit>().getNoms(widget.order);
            final ReturningInNom nom =
                context.read<ReturningInDataCubit>().scan(value);
            if (nom != ReturningInNom.empty) {
              showManualCountIncrementAlert(
                  context, nom.barcode.first.barcode, invoice, nom);
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
                      final String invoice = context
                          .read<ReturningInDataCubit>()
                          .state
                          .noms
                          .invoice;
                      context
                          .read<ReturningInDataCubit>()
                          .getNoms(widget.order);
                      final ReturningInNom nom =
                          context.read<ReturningInDataCubit>().scan(value);
                      if (nom != ReturningInNom.empty) {
                        showManualCountIncrementAlert(
                            context, nom.barcode.first.barcode, invoice, nom);
                      }
                    },
                  )
                : null),
      ),
    );
  }
}
