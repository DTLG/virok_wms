import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../ui/custom_keyboard/keyboard.dart';
import '../../../../../ui/widgets/alerts.dart';
import '../../cubit/placement_cubit.dart';
import '../../placement_repository/model/admission_nom.dart';

void showNomScanDialog(BuildContext context, AdmissionNom nom) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => BlocProvider.value(
            value: context.read<PlacementCubit>(),
            child: NomScanDialog(
              nom: nom,
            ),
          ));
}

class NomScanDialog extends StatelessWidget {
  const NomScanDialog({super.key, required this.nom});

  final AdmissionNom nom;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        await context.read<PlacementCubit>().clear();
        return true;
      },
      child: AlertDialog(
        iconPadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        icon: Align(
          alignment: Alignment.centerRight,
          child: IconButton(
              onPressed: () {
                context.read<PlacementCubit>().clear();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close)),
        ),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
              nom.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(
              height: 8,
            ),
            const CellInput(),
            const SizedBox(
              height: 5,
            ),
            NomInput(
              nom: nom,
            ),
            const SizedBox(
              height: 5,
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Кількість до розміщення:',
                  style: theme.textTheme.titleSmall,
                ),
                Text(
                  nom.qty.toStringAsFixed(0),
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
            BlocBuilder<PlacementCubit, PlacementState>(
              builder: (context, state) {
                double dialogSize = MediaQuery.of(context).size.height;
                final count = nom.count;
                return Text(
                  state.count == 0
                      ? count.toStringAsFixed(0)
                      : state.count.toStringAsFixed(0),
                  style: TextStyle(fontSize: dialogSize < 700 ? 65 : 120),
                );
              },
            )
          ]),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
        actions: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ManualInputButton(
                    nom: nom,
                  ),
                  SendButton(
                    nom: nom,
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class CellInput extends StatefulWidget {
  const CellInput({super.key});

  @override
  State<CellInput> createState() => _CellInputState();
}

class _CellInputState extends State<CellInput> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final cellValue =
        context.select((PlacementCubit cubit) => cubit.state.cell);
    controller.text == cellValue;
    return SizedBox(
      height: 45,
      child: TextField(
        autofocus: true,
        focusNode: focusNode,
        textInputAction: TextInputAction.next,
        textAlignVertical: TextAlignVertical.bottom,
        controller: controller,
        onSubmitted: (value) async {
          final res = await context.read<PlacementCubit>().checkCell(value);
          if (res == 0) {
            controller.clear();
            focusNode.requestFocus();
          }
        },
        decoration: const InputDecoration(hintText: 'Відскануйте комірку'),
      ),
    );
  }
}

class NomInput extends StatefulWidget {
  const NomInput({super.key, required this.nom});

  final AdmissionNom nom;

  @override
  State<NomInput> createState() => _NomInputState();
}

class _NomInputState extends State<NomInput> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final cellValue =
        context.select((PlacementCubit cubit) => cubit.state.cell);
    controller.text == cellValue;
    return SizedBox(
      height: 45,
      child: TextField(
        controller: controller,
        textAlignVertical: TextAlignVertical.bottom,
        focusNode: focusNode,
        onSubmitted: (value) {
          context.read<PlacementCubit>().scan(value, widget.nom);
          controller.clear();
          focusNode.requestFocus();
        },
        decoration: const InputDecoration(hintText: 'Відскануйте товар'),
      ),
    );
  }
}

class InputCountAlert extends StatefulWidget {
  const InputCountAlert(
      {super.key, required this.onChanged, required this.nom});

  final ValueChanged<String>? onChanged;
  final AdmissionNom nom;

  @override
  State<InputCountAlert> createState() => _InputCountAlertState();
}

class _InputCountAlertState extends State<InputCountAlert> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Spacer(),
        AlertDialog(
          iconPadding: const EdgeInsets.all(0),
          contentPadding: const EdgeInsets.only(bottom: 20),
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
              SizedBox(
                width: 70,
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  onChanged: widget.onChanged,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                ),
              ),
              const SizedBox(
                height: 20,
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
                  context.read<PlacementCubit>().manualCountIncrement(
                      controller.text,
                      widget.nom.qty.toDouble(),
                      widget.nom.count);
                  Navigator.pop(context);
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

void showCountAlert(
  BuildContext context,
  AdmissionNom nom,
) {
  showDialog(
      barrierColor: const Color.fromARGB(149, 0, 0, 0),
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<PlacementCubit>(),
          child: InputCountAlert(
            nom: nom,
            onChanged: (value) {
              if (value.split('').first == '-') {
                Alerts(context: context, msg: 'Введене відємне число')
                    .showError();
                value = '';
              } else {}
            },
          ),
        );
      });
}

class ManualInputButton extends StatelessWidget {
  const ManualInputButton({super.key, required this.nom});

  final AdmissionNom nom;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlacementCubit, PlacementState>(
      builder: (context, state) {
        return ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                    context.read<PlacementCubit>().state.count > 0
                        ? Colors.green
                        : Colors.grey)),
            onPressed: () {
              final state = context.read<PlacementCubit>().state;
              if (state.nomBarcode.isNotEmpty) {
                showCountAlert(context, nom);
              }
            },
            child: const Text('Ввести в ручну'));
      },
    );
  }
}

class SendButton extends StatelessWidget {
  const SendButton({super.key, required this.nom});

  final AdmissionNom nom;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          final state = context.read<PlacementCubit>().state;
          if (state.cell.isNotEmpty && state.nomBarcode.isNotEmpty) {
            context.read<PlacementCubit>().send(
                state.nomBarcode, state.cell, nom.incomingInvoice, nom.count);
            Navigator.pop(context);
          } else if (state.cell.isEmpty) {
            Alerts(msg: 'Відскануйте комірку', context: context).showError();
          } else if (state.nomBarcode.isEmpty) {
            Alerts(msg: 'Відскануйте товар', context: context).showError();
          }
        },
        child: const Text('Додати'));
  }
}
