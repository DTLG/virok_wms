import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/ui/theme/theme.dart';

import '../../../../../../ui/custom_keyboard/keyboard.dart';
import '../../../../../../ui/widgets/alerts.dart';
import '../../../../../../ui/widgets/widgets.dart';
import '../../../cubit/placement_cubit.dart';
import '../../../placement_repository/model/placement_nom.dart';

void showNomScanDialog(BuildContext context, PlacementNom nom) {
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

class NomScanDialog extends StatefulWidget {
  const NomScanDialog({super.key, required this.nom});

  final PlacementNom nom;

  @override
  State<NomScanDialog> createState() => _NomScanDialogState();
}

class _NomScanDialogState extends State<NomScanDialog> {
  final controller = TextEditingController();
  @override
  void initState() {
    context.read<PlacementCubit>().getNom(
          widget.nom.barcodes.first.barcode,
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        await context.read<PlacementCubit>().clear();
        return true;
      },
      child: BlocBuilder<PlacementCubit, PlacementState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AlertDialog(
                insetPadding: const EdgeInsets.fromLTRB(20, 7, 20, 0),
                iconPadding: EdgeInsets.zero,
                contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                icon: DialogHead(
                  article: widget.nom.article,
                  onPressed: () {
                    context.read<PlacementCubit>().clear();
                    Navigator.pop(context);
                  },
                ),
                content: SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                      state.nom == PlacementNom.empty
                          ? widget.nom.name
                          : state.nom.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Card(
                      margin: EdgeInsets.zero,
                      color: AppColors.dialogYellow,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Кількість залишку:',
                              style: theme.textTheme.titleSmall,
                            ),
                            Text(
                              state.nom == PlacementNom.empty
                                  ? widget.nom.allCount.toStringAsFixed(0)
                                  : state.nom.allCount.toStringAsFixed(0),
                              style: theme.textTheme.titleSmall!
                                  .copyWith(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Card(
                      margin: EdgeInsets.zero,
                      color: AppColors.dialogGreen,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Доступна кількість:',
                              style: theme.textTheme.titleSmall,
                            ),
                            Text(
                              state.nom == PlacementNom.empty
                                  ? widget.nom.freeCount.toStringAsFixed(0)
                                  : state.nom.freeCount.toStringAsFixed(0),
                              style: theme.textTheme.titleSmall!
                                  .copyWith(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Card(
                      margin: EdgeInsets.zero,
                      color: AppColors.dialogOrange,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Зарезервована кількість:',
                              style: theme.textTheme.titleSmall,
                            ),
                            Text(
                              state.nom == PlacementNom.empty
                                  ? widget.nom.reservedCount.toStringAsFixed(0)
                                  : state.nom.reservedCount.toStringAsFixed(0),
                              style: theme.textTheme.titleSmall!
                                  .copyWith(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      width: 100,
                      child: TextField(
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                        controller: controller,
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text('Введіть кількість'),
                    const SizedBox(
                      height: 5,
                    ),
                  ]),
                ),
                actionsPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        if (controller.text.isEmpty) return;
                        context.read<PlacementCubit>().createAdmisionPlacement(
                            widget.nom.barcodes.first.barcode, controller.text);
                        Navigator.pop(context);
                      },
                      child: const Text('Додати'))
                ],
              ),
              Keyboard(controller: controller)
            ],
          );
        },
      ),
    );
  }
}

class InputCountAlert extends StatefulWidget {
  const InputCountAlert(
      {super.key, required this.onChanged, required this.nom});

  final ValueChanged<String>? onChanged;
  final PlacementNom nom;

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
                  // context.read<PlacementCubit>().manualCountIncrement(
                  //     controller.text,
                  //     widget.nom.qty.toDouble(),
                  //     widget.nom.count);
                  // Navigator.pop(context);
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
  PlacementNom nom,
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

// class ManualInputButton extends StatelessWidget {
//   const ManualInputButton({super.key, required this.nom});

//   final AdmissionNom nom;

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<PlacementCubit, PlacementState>(
//       builder: (context, state) {
//         return ElevatedButton(
//             style: ButtonStyle(
//                 backgroundColor: MaterialStatePropertyAll(
//                     context.read<PlacementCubit>().state.count > 0
//                         ? Colors.green
//                         : Colors.grey)),
//             onPressed: () {
//               final state = context.read<PlacementCubit>().state;
//               if (state.nomBarcode.isNotEmpty) {
//                 showCountAlert(context, nom);
//               }
//             },
//             child: const Text('Ввести в ручну'));
//       },
//     );
//   }
// }


