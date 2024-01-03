import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/recharge/cubit/recharge_cubit.dart';
import 'package:virok_wms/feature/recharge/recharge_repository/models/recharge_noms.dart';

import '../../../../ui/widgets/general_button.dart';
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
    const textStyle = TextStyle(fontWeight: FontWeight.w500);
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [ const Text('Списано:',style: textStyle, ), Text(nom.countTake.toString(),style: textStyle,)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [ const Text('Розміщено:',style: textStyle,), Text(nom.countPut.toString(),style: textStyle,)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [ const Text('До розміщення:',style: textStyle,), Text(nom.qty.toString(),style: textStyle,)],
          )
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        SizedBox(
          width: 125,
          child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                nomScanDialog(context, nom, 1);
              },
              child: const Text(
                'Відібрати',
                style: TextStyle(fontSize: 17),
              )),
        ),
        SizedBox(
          width: 125,
          child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                nomScanDialog(context, nom, 0);
              },
              child: const Text(
                'Розмістити',
                style: TextStyle(fontSize: 17),
              )),
        )
      ],
    );
  }
}
