import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/return/cubits/return_data_cubit.dart';
import 'package:virok_wms/feature/return/return_repository/models/noms_model.dart';
import 'package:virok_wms/feature/return/return_repository/models/order.dart';
import 'package:virok_wms/feature/return/ui/widgets/dialog/count_input.dart';

import '../../../../ui/ui.dart';
import '../../../home_page/cubit/home_page_cubit.dart';

class ReturningInBarcodeInput extends StatefulWidget {
  const ReturningInBarcodeInput({super.key, required this.order});

  final ReturnOrder order;

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
        autofocus: true,
        controller: controller,
        focusNode: focusNode,
        textAlignVertical: TextAlignVertical.bottom,
        onSubmitted: (value) {
          final String invoice =
              context.read<ReturnDataCubit>().state.noms.invoice;
          if (controller.text.isNotEmpty) {
            context.read<ReturnDataCubit>().getNoms(widget.order);
            final ReturnNom nom = context.read<ReturnDataCubit>().scan(value);
            if (nom != ReturnNom.empty) {
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
                      final String invoice =
                          context.read<ReturnDataCubit>().state.noms.invoice;
                      context.read<ReturnDataCubit>().getNoms(widget.order);
                      final ReturnNom nom =
                          context.read<ReturnDataCubit>().scan(value);
                      if (nom != ReturnNom.empty) {
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
