import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/home_page/cubit/home_page_cubit.dart';
import 'package:virok_wms/feature/moving/moving_gate/cubit/moving_gate_order_data_cubit.dart';
import 'package:virok_wms/feature/moving/moving_gate/ui/widgets/dialog/nom_scan.dart';
import 'package:virok_wms/models/noms_model.dart';
import 'package:virok_wms/ui/widgets/camera_scaner_button.dart';

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
            context.read<NomsPageCubit>().getNoms(widget.docId);
            final Nom nom = context.read<NomsPageCubit>().search(value);
            if (nom != Nom.empty) {
              showNomInput(context, nom.codeCell, widget.docId,
                  nom.barcode.first.barcode, nom);
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
                      context.read<NomsPageCubit>().getNoms(widget.docId);
                      final Nom nom =
                          context.read<NomsPageCubit>().search(value);
                      if (nom != Nom.empty) {
                        showNomInput(context, nom.codeCell, widget.docId,
                            nom.barcode.first.barcode, nom);
                      }
                    },
                  )
                : null),
      ),
    );
  }
}
