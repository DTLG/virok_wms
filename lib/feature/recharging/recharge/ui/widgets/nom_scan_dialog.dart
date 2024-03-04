import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/home_page/cubit/home_page_cubit.dart';
import 'package:virok_wms/feature/recharging/recharge/cubit/recharge_cubit.dart';
import 'package:virok_wms/feature/recharging/recharge/recharge_repository/models/recharge_noms.dart';
import 'package:virok_wms/ui/ui.dart';


void nomScanDialog(BuildContext context, RechargeNom nom, int type) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => BlocProvider.value(
            value: context.read<RechargeCubit>(),
            child: NomScanDialog(
              nom: nom,
              type: type,
            ),
          ));
}

class NomScanDialog extends StatelessWidget {
  const NomScanDialog({super.key, required this.nom, required this.type});

  final RechargeNom nom;
  final int type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool cameraScaner = context.read<HomePageCubit>().state.cameraScaner;

    return WillPopScope(
      onWillPop: () async {
        await context.read<RechargeCubit>().clear();
        return true;
      },
      child: AlertDialog(
        iconPadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        icon: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 50,
            ),
            Text(
              type == 0 ? 'Розміщення' : 'Відбирання',
              style: theme.textTheme.titleSmall,
            ),
            IconButton(
                onPressed: () {
                  context.read<RechargeCubit>().clear();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close))
          ],
        ),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
              nom.tovar,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(
              height: 5,
            ),
            ColorContainer(
              color: AppColors.dialogYellow,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Артикул:',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                  Text(
                    nom.article,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            ColorContainer(
              color: AppColors.dialogOrange,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    type == 1 ? 'Відібрати з:' : 'Розмістити в:',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                  Text(
                    type == 1 ? nom.nameCellFrom : nom.nameCellTo,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            CellInput(
              nom: nom,
              type: type,
              cameraScaner: cameraScaner,
            ),
            const SizedBox(
              height: 5,
            ),
            NomInput(
              nom: nom,
              type: type,
              cameraScaner: cameraScaner,
            ),
            const SizedBox(
              height: 5,
            ),
            const SizedBox(
              height: 8,
            ),
            ColorContainer(
              color: AppColors.dialogGreen,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Кількість до ${type == 1 ? 'відбирання' : 'розміщення'}:',
                    style: theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                  Text(
                    nom.qty.toStringAsFixed(0),
                    style: theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                ],
              ),
            ),
            BlocBuilder<RechargeCubit, RechargeState>(
              builder: (context, state) {
                double dialogSize = MediaQuery.of(context).size.height;
                final count = type == 1 ? nom.countTake : nom.countPut;

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
                    type: type,
                  ),
                  SendButton(
                    nom: nom,
                    type: type,
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
  const CellInput(
      {super.key,
      required this.nom,
      required this.type,
      required this.cameraScaner});

  final RechargeNom nom;
  final int type;
  final bool cameraScaner;

  @override
  State<CellInput> createState() => _CellInputState();
}

class _CellInputState extends State<CellInput> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final cellValue = context.select((RechargeCubit cubit) => cubit.state.cell);
    controller.text == cellValue;
    return SizedBox(
      height: 45,
      child: TextField(
        autofocus: widget.cameraScaner ? false : true,
        focusNode: focusNode,
        textInputAction: TextInputAction.next,
        textAlignVertical: TextAlignVertical.bottom,
        controller: controller,
        onSubmitted: (value) async {
          final res = context.read<RechargeCubit>().scanCell(
              widget.type == 1 ? widget.nom.codCellFrom : widget.nom.codCellTo,
              value);
          if (res == 0) {
            controller.clear();
            focusNode.requestFocus();
          }
        },
        decoration: InputDecoration(
            hintText: 'Відскануйте комірку',
            suffixIcon: widget.cameraScaner
                ? CameraScanerButton(
                    scan: (value) {
                      context.read<RechargeCubit>().scanCell(
                          widget.type == 1
                              ? widget.nom.codCellFrom
                              : widget.nom.codCellTo,
                          value);
                    },
                  )
                : null),
      ),
    );
  }
}

class NomInput extends StatefulWidget {
  const NomInput(
      {super.key,
      required this.nom,
      required this.type,
      required this.cameraScaner});

  final RechargeNom nom;
  final int type;
  final bool cameraScaner;

  @override
  State<NomInput> createState() => _NomInputState();
}

class _NomInputState extends State<NomInput> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: controller,
        textAlignVertical: TextAlignVertical.bottom,
        focusNode: focusNode,
        onSubmitted: (value) {
          widget.type == 1
              ? context
                  .read<RechargeCubit>()
                  .scanNomWritingOff(value, widget.nom)
              : context
                  .read<RechargeCubit>()
                  .scanNomPlacement(value, widget.nom);
          controller.clear();
          focusNode.requestFocus();
        },
        decoration: InputDecoration(
            hintText: 'Відскануйте товар',
            suffixIcon: widget.cameraScaner
                ? CameraScanerButton(
                    scan: (value) {
                      widget.type == 1
                          ? context
                              .read<RechargeCubit>()
                              .scanNomWritingOff(value, widget.nom)
                          : context
                              .read<RechargeCubit>()
                              .scanNomPlacement(value, widget.nom);
                    },
                  )
                : null),
      ),
    );
  }
}

class InputCountAlert extends StatefulWidget {
  const InputCountAlert(
      {super.key,
      required this.onChanged,
      required this.nom,
      required this.type});

  final ValueChanged<String>? onChanged;
  final RechargeNom nom;
  final int type;

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
                  context.read<RechargeCubit>().manualCountIncrement(
                      controller.text, widget.type, widget.nom);
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

void showCountAlert(BuildContext context, RechargeNom nom, int type) {
  showDialog(
      barrierColor: const Color.fromARGB(149, 0, 0, 0),
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<RechargeCubit>(),
          child: InputCountAlert(
            nom: nom,
            type: type,
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
  const ManualInputButton({super.key, required this.nom, required this.type});

  final RechargeNom nom;
  final int type;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RechargeCubit, RechargeState>(
      builder: (context, state) {
        return ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                    context.read<RechargeCubit>().state.count > 0
                        ? Colors.green
                        : Colors.grey)),
            onPressed: () {
              final state = context.read<RechargeCubit>().state;
              if (state.nomBarcode.isNotEmpty) {
                showCountAlert(context, nom, type);
              }
            },
            child:
                const Text('Ввести в ручну', style: TextStyle(fontSize: 16)));
      },
    );
  }
}

class SendButton extends StatelessWidget {
  const SendButton({super.key, required this.nom, required this.type});

  final RechargeNom nom;
  final int type;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          final state = context.read<RechargeCubit>().state;
          if (state.cell.isEmpty) {
            Alerts(msg: 'Відскануйте комірку', context: context).showError();
            return;
          }
          if (state.nomBarcode.isEmpty) {
            Alerts(msg: 'Відскануйте товар', context: context).showError();
            return;
          }
          context
              .read<RechargeCubit>()
              .send(type, state.nomBarcode, state.cell, nom.taskNumber, nom);
          Navigator.pop(context);
        },
        child: Text(
          type == 0 ? 'Розмістити' : 'Відібрати',
          style: const TextStyle(fontSize: 16),
        ));
  }
}
