import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/returning/return_epic/cubit/return_epic_cubit.dart';
import 'package:virok_wms/feature/returning/return_epic/model/return_epic_nom.dart';
import 'package:virok_wms/ui/theme/app_color.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';

import '../../../../../../ui/custom_keyboard/keyboard.dart';

void manualCountIncrementDialog(
    BuildContext context, String nomBarcode, ReturnEpicNom nom) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<ReturnEpicCubit>(),
          child: ManualCountIncrementAlert(
            nomBarcode: nomBarcode,
            nom: nom,
          ),
        );
      });
}

class ManualCountIncrementAlert extends StatefulWidget {
  const ManualCountIncrementAlert(
      {super.key, required this.nomBarcode, required this.nom});

  final String nomBarcode;
  final ReturnEpicNom nom;

  @override
  State<ManualCountIncrementAlert> createState() =>
      _ManualCountIncrementAlertState();
}

class _ManualCountIncrementAlertState extends State<ManualCountIncrementAlert> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  String nomStatus = '';

  @override
  void initState() {
    context.read<ReturnEpicCubit>().getNom(
        widget.nom.incomingInvoiceNumber,
        widget.nom.barcodes.first.barcode,
        widget.nom.nomStatus,
        widget.nom.number);
    nomStatus = widget.nom.nomStatus;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        await context.read<ReturnEpicCubit>().clear();
        return true;
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BlocBuilder<ReturnEpicCubit, ReturnEpicState>(
            builder: (context, state) {
              return AlertDialog(
                insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                iconPadding: const EdgeInsets.all(0),
                contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                actionsPadding: const EdgeInsets.only(bottom: 5),
                icon: DialogHead(
                  title: widget.nom.article,
                  onPressed: () {
                    context.read<ReturnEpicCubit>().clear();
                    Navigator.pop(context);
                  },
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.nom == ReturnEpicNom.empty
                          ? widget.nom.tovar
                          : state.nom.tovar,
                      style: theme.textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
                            Text('Номер:',
                                style: theme.textTheme.titleSmall!
                                    .copyWith(color: Colors.black)),
                            Text(
                                state.nom == ReturnEpicNom.empty
                                    ? widget.nom.incomingInvoiceNumber
                                    : state.nom.incomingInvoiceNumber,
                                style: theme.textTheme.titleSmall?.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                          ],
                        ),
                      ),
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
                            Text('Кількість в замовленні:',
                                style: theme.textTheme.titleSmall!
                                    .copyWith(color: Colors.black)),
                            Text(
                                state.nom == ReturnEpicNom.empty
                                    ? widget.nom.qty.toStringAsFixed(0)
                                    : state.nom.qty.toStringAsFixed(0),
                                style: theme.textTheme.titleSmall?.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
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
                            Text('Відскановано:',
                                style: theme.textTheme.titleSmall!
                                    .copyWith(color: Colors.black)),
                            Text(
                                state.nom == ReturnEpicNom.empty
                                    ? widget.nom.count.toStringAsFixed(0)
                                    : state.nom.count.toStringAsFixed(0),
                                style: theme.textTheme.titleSmall?.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: 90,
                              child: TextField(
                                focusNode: focusNode,
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
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 28),
                          child: PopupMenuButton(
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'Кондиція',
                                child: Text('Кондиція'),
                              ),
                              const PopupMenuItem(
                                value: 'Брак',
                                child: Text('Брак'),
                              ),
                              const PopupMenuItem(
                                value: 'Уцінка',
                                child: Text('Уцінка'),
                              ),
                            ],
                            onSelected: (value) {
                              setState(() {
                                nomStatus = value;
                              });
                            },
                            offset: const Offset(1, -1),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18.0))),
                            child: Container(
                              height: 50,
                              width: 110,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 100, 100, 100)),
                                  borderRadius: BorderRadius.circular(18)),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(nomStatus),
                                  const Icon(Icons.arrow_drop_down_rounded)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        String barcode = '';
                        if (controller.text.isNotEmpty &&
                            controller.text != "0") {
                          for (var element in state.nom.barcodes) {
                            if (element.ratio == 1) {
                              barcode = element.barcode;
                              break;
                            }
                          }

                          context.read<ReturnEpicCubit>().scan(
                              barcode,
                              widget.nom,
                              double.parse(controller.text),
                              nomStatus);
                          if (controller.text.length < 6) {
                            Navigator.pop(context);
                            return;
                          }
                          controller.clear();
                          focusNode.requestFocus();
                        }
                      },
                      child: const Text(
                        'Додати',
                      ))
                ],
              );
            },
          ),
          BottomSheet(
            onClosing: () {},
            builder: (context) => Keyboard(
              controller: controller,
            ),
          )
        ],
      ),
    );
  }
}
