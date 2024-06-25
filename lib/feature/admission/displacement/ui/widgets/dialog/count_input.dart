import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/ui/theme/app_color.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';

import '../../../../../../ui/custom_keyboard/keyboard.dart';
import '../../../cubits/displacement_order_data_cubit.dart';
import '../../../models/models.dart';

void showManualCountIncrementAlert(BuildContext context, String nomBarcode,
    String invoice, DisplacementNom nom) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<DisplacementOrderDataCubit>(),
          child: ManualCountIncrementAlert(
            nomBarcode: nomBarcode,
            invoice: invoice,
            nom: nom,
          ),
        );
      });
}

class ManualCountIncrementAlert extends StatefulWidget {
  const ManualCountIncrementAlert(
      {super.key,
      required this.nomBarcode,
      required this.invoice,
      required this.nom});

  final String nomBarcode;
  final String invoice;
  final DisplacementNom nom;

  @override
  State<ManualCountIncrementAlert> createState() =>
      _ManualCountIncrementAlertState();
}

class _ManualCountIncrementAlertState extends State<ManualCountIncrementAlert> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    context
        .read<DisplacementOrderDataCubit>()
        .getNom(widget.invoice, widget.nomBarcode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        await context.read<DisplacementOrderDataCubit>().clear();
        return true;
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BlocBuilder<DisplacementOrderDataCubit, DisplacementOrderDataState>(
            builder: (context, state) {
              return AlertDialog(
                insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                iconPadding: const EdgeInsets.all(0),
                contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                actionsPadding: const EdgeInsets.only(bottom: 5),
                icon: DialogHead(
                  title: widget.nom.article,
                  onPressed: () {
                    context.read<DisplacementOrderDataCubit>().clear();
                    Navigator.pop(context);
                  },
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.nom == DisplacementNom.empty
                          ? widget.nom.name
                          : state.nom.name,
                      style: theme.textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
                                state.nom == DisplacementNom.empty
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
                                state.nom == DisplacementNom.empty
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

                          context.read<DisplacementOrderDataCubit>().addNom(
                              barcode,
                              widget.invoice,
                              double.parse(controller.text));
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
