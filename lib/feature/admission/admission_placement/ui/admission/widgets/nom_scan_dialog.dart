import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/admission/admission_placement/cubit/admission_placement_cubit.dart';
import 'package:virok_wms/feature/admission/admission_placement/placement_repository/model/admission_placement_nom.dart';
import 'package:virok_wms/ui/custom_keyboard/keyboard.dart';
import 'package:virok_wms/ui/theme/app_color.dart';

import '../../../../../../ui/widgets/widgets.dart';

void showNomScanDialog(BuildContext context, AdmissionNom nom) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => BlocProvider.value(
            value: context.read<AdmissionPlacementCubit>(),
            child: NomScanDialog(
              nom: nom,
            ),
          ));
}

class NomScanDialog extends StatefulWidget {
  const NomScanDialog({super.key, required this.nom});

  final AdmissionNom nom;

  @override
  State<NomScanDialog> createState() => _NomScanDialogState();
}

class _NomScanDialogState extends State<NomScanDialog> {
  @override
  void initState() {
    context
        .read<AdmissionPlacementCubit>()
        .getNom(widget.nom.barcodes.first.barcode, widget.nom.taskNumber);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        await context.read<AdmissionPlacementCubit>().clear();
        return true;
      },
      child: AlertDialog(
        iconPadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        icon:
        
                 DialogHead(title: widget.nom.article, onPressed: () {
                  context.read<AdmissionPlacementCubit>().clear();
                  Navigator.pop(context);
                },)
        ,
                
                
        
        
    
        content: BlocBuilder<AdmissionPlacementCubit, AdmissionPlacementState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(
                  state.nom == AdmissionNom.empty ? widget.nom.name : state.nom.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 8,
                ),
                const CellInput(),
                const SizedBox(
                  height: 5,
                ),
                NomInput(
                  nom: widget.nom,
                ),
                const SizedBox(
                  height: 5,
                ),
                const SizedBox(
                  height: 8,
                ),
                  Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.dialogGreen),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Кількість в замовленні:',
                        style: theme.textTheme.titleSmall,
                      ),
                      Text(
                        state.nom == AdmissionNom.empty?
                widget.nom.qty.toStringAsFixed(0):
                  state.nom.qty.toStringAsFixed(0),
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<AdmissionPlacementCubit, AdmissionPlacementState>(
                  builder: (context, state) {
                    double dialogSize = MediaQuery.of(context).size.height;
                    final count = widget.nom.count;
                    return Text(
                      state.count == 0
                          ? count.toStringAsFixed(0)
                          : state.count.toStringAsFixed(0),
                      style: TextStyle(fontSize: dialogSize < 700 ? 65 : 120),
                    );
                  },
                )
              ]),
            );
          },
        ),
        actionsPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
        actions: [
          Column(
            children: [
               Row(
                 children: [
                   ElevatedButton(
                              style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Color.fromARGB(255, 140, 193, 219))),
                              onPressed: () {
                                final state = context.read<AdmissionPlacementCubit>().state;
                                showDialog(
                                  barrierColor: const Color.fromARGB(150, 0, 0, 0),
                                  context: context,
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<AdmissionPlacementCubit>(),
                                    child: ChangeQuantity(
                                      qty: state.nom.qty,
                                      nom: state.nom,
                                      docId: widget.nom.taskNumber,
                                      count: state.nom.count,
                                    ),
                                  ),
                                );
                              },
                              child: const SizedBox(
                                width: 120,
                                child: Text(
                                  'Коригувати замовлення',
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              )),
                              const Spacer()
                 ],
               ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ManualInputButton(
                    nom: widget.nom,
                  ),
                  SendButton(
                    nom: widget.nom,
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
        context.select((AdmissionPlacementCubit cubit) => cubit.state.cell);
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
          final res =
              await context.read<AdmissionPlacementCubit>().checkCell(value);
          if (res == false) {
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
        context.select((AdmissionPlacementCubit cubit) => cubit.state.cell);
    controller.text == cellValue;
    return SizedBox(
      height: 45,
      child: TextField(
        controller: controller,
        textAlignVertical: TextAlignVertical.bottom,
        focusNode: focusNode,
        onSubmitted: (value) {
          context.read<AdmissionPlacementCubit>().scan(value, widget.nom);
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
                  context.read<AdmissionPlacementCubit>().manualCountIncrement(
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
          value: context.read<AdmissionPlacementCubit>(),
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
    return BlocBuilder<AdmissionPlacementCubit, AdmissionPlacementState>(
      builder: (context, state) {
        return ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                    context.read<AdmissionPlacementCubit>().state.count > 0
                        ? Colors.green
                        : Colors.grey)),
            onPressed: () {
              final state = context.read<AdmissionPlacementCubit>().state;
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
          final state = context.read<AdmissionPlacementCubit>().state;
          if (state.cell.isNotEmpty && state.nomBarcode.isNotEmpty) {
            context
                .read<AdmissionPlacementCubit>()
                .send(state.nomBarcode, state.cell, nom.taskNumber, nom.count);
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


class ChangeQuantity extends StatefulWidget {
  const ChangeQuantity(
      {super.key,
      required this.qty,
      required this.nom,
      required this.docId,
      required this.count});

  final double qty;
  final double count;
  final AdmissionNom nom;
  final String docId;

  @override
  State<ChangeQuantity> createState() => _ChangeQuantityState();
}

class _ChangeQuantityState extends State<ChangeQuantity> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        const Spacer(),
        AlertDialog(
          iconPadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          icon: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 50,
              ),
              Text(
                "Зміна кількості",
                style: theme.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close))
            ],
          ),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Кількість в замовленні:'),
              trailing: Text(widget.qty.toString()),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              autofocus: true,
              controller: controller,
              decoration: const InputDecoration(hintText: 'Введіть кількість'),
            ),
            const SizedBox(
              height: 5,
            ),
          ]),
          actionsPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
                onPressed: () {
                  double inputCount = double.parse(controller.text);
                  if (controller.text.isNotEmpty) {
                    if (inputCount > widget.qty) {
                      Alerts(
                              msg: 'Введена більша кількість ніж в замовленні',
                              context: context)
                          .showError();
                    } else if (inputCount < widget.count) {
                      Alerts(
                              msg: 'Введена менаша кількість ніж  відскановано',
                              context: context)
                          .showError();
                    } else if (inputCount == widget.qty) {
                      Alerts(
                              msg:
                                  'Введена та сама кількість що й в замовленні',
                              context: context)
                          .showError();
                    } else if (inputCount == 0) {
                      Alerts(msg: 'Введене значення 0', context: context)
                          .showError();
                    } else {
                      context
                          .read<
                          AdmissionPlacementCubit>()
                          .changeQty(controller.text, widget.nom.taskNumber);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('Змінити'))
          ],
        ),
        Keyboard(
          controller: controller,
        )
      ],
    );
  }
}
