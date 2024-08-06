import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/recharging/recharge/cubit/recharge_cubit.dart';
import 'package:virok_wms/feature/recharging/recharge/recharge_repository/models/recharge_noms.dart';
import 'package:virok_wms/ui/custom_keyboard/keyboard.dart';
import 'package:virok_wms/ui/theme/app_color.dart';

import '../../../../../ui/widgets/widgets.dart';
import 'nom_scan_dialog.dart';

checkIsStartedDialog(BuildContext context, RechargeNom nom) {
  showDialog(
    context: context,
    builder: (_) => BlocProvider.value(
      value: context.read<RechargeCubit>(),
      child: CheckIsStartedDialog(
        nom: nom,
        taskNumber: nom.taskNumber,
      ),
    ),
  );
}

class CheckIsStartedDialog extends StatelessWidget {
  const CheckIsStartedDialog(
      {super.key, required this.taskNumber, required this.nom});

  final String taskNumber;
  final RechargeNom nom;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      iconPadding: EdgeInsets.zero,
      icon: Align(
        alignment: Alignment.centerRight,
        child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close)),
      ),
      content: Text(
        'Розпочати сканування',
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        Row(
          children: [
            Expanded(
                child: GeneralButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<RechargeCubit>().startScan(taskNumber);
                      writeOffOrPlacement(context, nom);
                    },
                    lable: 'Так')),
            Expanded(
                child: GeneralButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    lable: 'Ні')),
          ],
        )
      ],
      contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
      actionsPadding: EdgeInsets.zero,
    );
  }
}

writeOffOrPlacement(BuildContext context, RechargeNom nom) {
  showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
            value: context.read<RechargeCubit>(),
            child: WriteOffOrPlacementDialog(
              nom: nom,
            ),
          ));
}

class WriteOffOrPlacementDialog extends StatelessWidget {
  const WriteOffOrPlacementDialog({super.key, required this.nom});

  final RechargeNom nom;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const textStyle =
        TextStyle(fontWeight: FontWeight.w500, color: Colors.black);
    return AlertDialog(
      iconPadding: EdgeInsets.zero,
      icon: Align(
        alignment: Alignment.centerRight,
        child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close)),
      ),
      contentPadding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ColorContainer(
            color: AppColors.dialogYellow,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Списати з:',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                    Text(
                      nom.nameCellFrom,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                  ],
                ),
                Divider(
                  height: 15,
                  color: Colors.grey[600],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Списано:',
                      style: textStyle,
                    ),
                    Text(
                      nom.countTake.toString(),
                      style: textStyle,
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          ColorContainer(
            color: AppColors.dialogOrange,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Розмістити в:',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                    Text(
                      nom.nameCellTo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                  ],
                ),
                Divider(
                  height: 15,
                  color: Colors.grey[600],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Розміщено:',
                      style: textStyle,
                    ),
                    Text(
                      nom.countPut.toString(),
                      style: textStyle,
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          ColorContainer(
            color: AppColors.dialogGreen,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'До розміщення:',
                  style: textStyle,
                ),
                Text(
                  nom.qty.toString(),
                  style: textStyle,
                )
              ],
            ),
          )
        ],
      ),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 130,
              child: ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 140, 193, 219))),
                  onPressed: () {
                    showDialog(
                      barrierColor: const Color.fromARGB(150, 0, 0, 0),
                      context: context,
                      builder: (_) => BlocProvider.value(
                        value: context.read<RechargeCubit>(),
                        child: ChangeQuantity(
                          qty: nom.qty,
                          nom: nom,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Змінити кількість',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  )),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 130,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);

                        nomScanDialog(context, nom, 1);
                      },
                      child: const Text(
                        'Відібрати',
                        style: TextStyle(fontSize: 16),
                      )),
                ),
                SizedBox(
                  width: 130,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        nomScanDialog(context, nom, 0);
                      },
                      child: const SizedBox(
                        child: Text(
                          'Розмістити',
                          style: TextStyle(fontSize: 16),
                        ),
                      )),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}

class ChangeQuantity extends StatefulWidget {
  const ChangeQuantity({
    super.key,
    required this.qty,
    required this.nom,
  });

  final double qty;
  final RechargeNom nom;

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
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]*')),
              ],
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
                    context
                        .read<RechargeCubit>()
                        .changeQty(inputCount, widget.nom);
                    Navigator.pop(context);
                    Navigator.pop(context);
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
