import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../ui/custom_keyboard/keyboard.dart';
import '../../../cubits/displacement_order_data_cubit.dart';
import '../../../displacement_repository/models/noms_model.dart';

void showManualCountIncrementAlert(
    BuildContext context, DisplacementNom nom, String invoice) {
  showDialog(
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<DisplacementOrderDataCubit>(),
          child: ManualCountIncrementAlert(
            nom: nom,
            invoice: invoice,
          ),
        );
      });
}

class ManualCountIncrementAlert extends StatefulWidget {
  const ManualCountIncrementAlert(
      {super.key,
      required this.nom,
      required this.invoice});

  final DisplacementNom nom;
  final String invoice;

  @override
  State<ManualCountIncrementAlert> createState() =>
      _ManualCountIncrementAlertState();
}

class _ManualCountIncrementAlertState extends State<ManualCountIncrementAlert> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AlertDialog(
          iconPadding: const EdgeInsets.all(0),
          contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
          actionsPadding: const EdgeInsets.only(bottom: 5),
          icon: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.nom.name,
                style: theme.textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Кількість в замовленні:',
                      style: theme.textTheme.titleSmall),
                  Text(widget.nom.qty.toString(),
                      style: theme.textTheme.titleSmall),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Відскановано:', style: theme.textTheme.titleSmall),
                  Text(widget.nom.count.toString(),
                      style: theme.textTheme.titleSmall),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 70,
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Введіть кількість',
                style: theme.textTheme.titleMedium,
              )
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
                onPressed: () {
                  String barcode = '';
                  if (controller.text.isNotEmpty && controller.text != "0") {
                    for (var element in widget.nom.barcode) {
                      if (element.ratio == 1) {
                        barcode = element.barcode;
                        break;
                      }
                    }

                    context.read<DisplacementOrderDataCubit>().scan(
                        barcode, widget.invoice, double.parse(controller.text));
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Додати',
                ))
          ],
        ),
        BottomSheet(
          onClosing: () {},
          builder: (context) => Keyboard(
            controller: controller,
          ),
        )
      ],
    );
  }
}
