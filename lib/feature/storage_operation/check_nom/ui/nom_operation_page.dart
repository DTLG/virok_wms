import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/ui/theme/app_color.dart';

import 'package:virok_wms/ui/widgets/alerts.dart';

import '../check_nom_repo/models/barcodes_noms.dart';
import '../cubit/check_nom_list_cubit.dart';
import '../cubit/nom_operations_cubit.dart';

class CheckNomPage extends StatelessWidget {
  const CheckNomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final BarcodesNom nom = arguments['nom'] as BarcodesNom;

    final CheckNomListCubit checkNomListCubit =
        arguments['cubit'] as CheckNomListCubit;

    return BlocProvider(
      create: (context) => NomOperationsCubit(),
      child: CheckNomView(
        nom: nom,
        checkNomListCubit: checkNomListCubit,
      ),
    );
  }
}

class CheckNomView extends StatelessWidget {
  const CheckNomView(
      {super.key, required this.nom, required this.checkNomListCubit});

  final BarcodesNom nom;
  final CheckNomListCubit checkNomListCubit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.select((NomOperationsCubit cubit) => cubit.state);

    final bool barcodeGenerationButton = state.barcodeGenerationButton;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        actions: [
          barcodeGenerationButton
              ? AppBarButton(
                  nom: nom,
                )
              : const SizedBox()
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                nom.name,
                style: theme.textTheme.titleLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 10,
              ),
              BlocConsumer<NomOperationsCubit, NomOperationsState>(
                listener: (context, state) {
                  if (state.status.isError) {
                    Alerts(msg: state.errorMassage, context: context)
                        .showError();
                  }
                },
                buildWhen: (previous, current) =>
                    current.status.isSuccess && previous.status.isSuccess,
                builder: (context, state) {
                  context.read<NomOperationsCubit>().getActivButton();
                  if (state.status.isInitial) {
                    return BarcodesCard(
                      nom: nom,
                    );
                  }
                  if (state.status.isSuccess) {
                    return BarcodesCard(
                      nom: state.nom,
                    );
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(
                height: 10,
              ),
              CellsCard(
                nom: nom,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BarcodesCard extends StatelessWidget {
  const BarcodesCard({
    super.key,
    required this.nom,
  });

  final BarcodesNom nom;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.select((NomOperationsCubit cubit) => cubit.state);

    final bool barcodeLablePrintButton = state.barcodeLablePrintButton;
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 235, 235, 235),
          borderRadius: BorderRadius.circular(20)),
      height: nom.barodes.length > 5
          ? 225
          : nom.barodes.isEmpty
              ? 40
              : 30 + (nom.barodes.length * 40),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          nom.barodes.isNotEmpty
              ? Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Штрихкод (${nom.barodes.length})'),
                          const Text('Коефіцієнт'),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: ListView.separated(
                        itemCount: nom.barodes.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              barcodeLablePrintButton
                                  ? showPrintAlertAlert(
                                      context,
                                      nom,
                                      nom.barodes[index].barcode,
                                      nom.barodes[index].ratio)
                                  : () {};
                            },
                            child: SizedBox(
                              height: 30,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(nom.barodes[index].barcode,
                                      style: theme.textTheme.titleSmall!
                                          .copyWith(fontSize: 13)),
                                  const Spacer(),
                                  Text(nom.barodes[index].ratio.toString(),
                                      style: theme.textTheme.titleSmall),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  barcodeLablePrintButton
                                      ? const Icon(Icons.print)
                                      : const SizedBox()
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(
                          height: 0,
                        ),
                      )),
                    ],
                  ),
                )
              : Text('Товар не має жодного штрихкоду',
                  style: theme.textTheme.titleSmall),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}

class CellsCard extends StatelessWidget {
  const CellsCard({super.key, required this.nom});

  final BarcodesNom nom;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 235, 235, 235),
          borderRadius: BorderRadius.circular(20)),
      height: nom.cells.length > 5
          ? 225
          : nom.cells.isEmpty
              ? 40
              : 30 + (nom.cells.length * 40),
      child: nom.cells.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Комірка (${nom.cells.length})'),
                    const Text('К-ть'),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: nom.cells.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(nom.cells[index].nameCell,
                              style: theme.textTheme.titleSmall),
                          Text(nom.cells[index].count.toStringAsFixed(0),
                              style: theme.textTheme.titleSmall),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(
                    height: 0,
                  ),
                )),
              ],
            )
          : Text(
              'Даний товар не нажелить жодній комірці',
              style: theme.textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
    );
  }
}

showNomInfoAlert(BuildContext context, BarcodesNom nom) {
  showDialog(
    context: context,
    builder: (_) {
      return BlocProvider.value(
        value: context.read<NomOperationsCubit>(),
        child: NewBarcodeInput(
          nom: nom,
        ),
      );
    },
  );
}

class NewBarcodeInput extends StatefulWidget {
  const NewBarcodeInput({super.key, required this.nom});

  final BarcodesNom nom;

  @override
  State<NewBarcodeInput> createState() => _NewBarcodeInputState();
}

class _NewBarcodeInputState extends State<NewBarcodeInput> {
  final controller = TextEditingController();
  final ratioController = TextEditingController();
  final focusNode = FocusNode();

  bool _switchValue = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(_switchValue ? 'Штука' : 'Упаковка'),
        Switch(
          value: _switchValue,
          onChanged: (value) {
            setState(() => _switchValue = value);
          },
        )
      ]),
      iconPadding: const EdgeInsets.fromLTRB(20, 5, 5, 0),
      contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            autofocus: true,
            controller: controller,
            focusNode: focusNode,
            onSubmitted: (value) {
              focusNode.nextFocus();
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                hintText: 'Згенерувати штрихкод',
                suffixIcon: GenerationButoon(
                  controller: controller,
                )),
          ),
          const SizedBox(
            height: 10,
          ),
          _switchValue
              ? const SizedBox()
              : TextField(
                  autofocus: true,
                  controller: ratioController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Кратність',
                  ),
                ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
            onPressed: () {
              bool barThisNom = false;
              if (controller.text.isEmpty) return;
              for (var bar in widget.nom.barodes) {
                if (bar.barcode == controller.text) {
                  barThisNom = true;
                }
              }
              if (barThisNom) {
                Alerts(msg: "Штрихкод вже існує", context: context).showError();
                return;
              }
              if (widget.nom.article.isEmpty) {
                Alerts(msg: "Відсутній артикул", context: context).showError();
                return;
              }
              if (_switchValue == true) {
                context.read<NomOperationsCubit>().sendBar(
                    'send_barcode',
                    '${widget.nom.article} ${controller.text}',
                    widget.nom.article);
                Navigator.pop(context);
              } else {
                if (ratioController.text.isNotEmpty) {
                  context.read<NomOperationsCubit>().sendBar(
                      'send_pack_barcode',
                      '${widget.nom.article} ${controller.text} ${ratioController.text}',
                      widget.nom.article);
                  Navigator.pop(context);
                } else {
                  Alerts(msg: "Введіть кратність", context: context)
                      .showError();
                }
              }
            },
            child: const SizedBox(
              height: 50,
              child: Center(
                child: Text(
                  'Підвердити',
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
            ))
      ],
    );
  }
}

class GenerationButoon extends StatelessWidget {
  const GenerationButoon({
    super.key,
    required this.controller,
  });
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          final DateTime now = DateTime.now();

          String genBar = now.millisecondsSinceEpoch
              .toString()
              .replaceFirst(RegExp(r'1'), '', 0);
          controller.text = genBar.checkDigitCalculation;
        },
        child: const Icon(Icons.add));
  }
}

extension on String {
  String get checkDigitCalculation {
    int oddSum = 0;
    int evenSum = 0;
    int totalSum = 0;
    String rev = toString().split('').reversed.join('');
    for (int i = 0; i < rev.length; i++) {
      int digit = int.parse(rev[i]);
      i % 2 == 0 ? oddSum += digit : evenSum += digit;
    }
    totalSum = oddSum * 3 + evenSum;
    int digit = int.parse(totalSum.toString().split('').last);

    return this + (digit == 0 ? 0 : 10 - digit).toString();
  }
}

showPrintAlertAlert(
    BuildContext context, BarcodesNom nom, String barcode, int ratio) {
  showDialog(
    context: context,
    builder: (_) {
      return BlocProvider.value(
        value: context.read<NomOperationsCubit>(),
        child: PrintAlert(
          nom: nom,
          barcode: barcode,
          ratio: ratio,
        ),
      );
    },
  );
}

class PrintAlert extends StatelessWidget {
  const PrintAlert(
      {super.key,
      required this.nom,
      required this.barcode,
      required this.ratio});

  final BarcodesNom nom;
  final String barcode;
  final int ratio;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            nom.name,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Артикул:'),
                SizedBox(
                    width: 150,
                    child: Text(nom.article,
                        textAlign: TextAlign.end,
                        style:
                            theme.textTheme.titleSmall!.copyWith(fontSize: 18)))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Штрихкод:'),
                SizedBox(
                  width: 150,
                  child: Text(barcode,
                      textAlign: TextAlign.end,
                      style:
                          theme.textTheme.titleSmall!.copyWith(fontSize: 18)),
                ),
              ],
            ),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
            onPressed: () {
              context
                  .read<NomOperationsCubit>()
                  .printLable(nom, barcode, ratio);
            },
            child: const SizedBox(
              height: 50,
              child: Center(
                child: Text(
                  'Друк',
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
            ))
      ],
    );
  }
}

class AppBarButton extends StatelessWidget {
  const AppBarButton({super.key, required this.nom});

  final BarcodesNom nom;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          showNomInfoAlert(context, nom);
        },
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(AppColors.darkBlue)),
        child: SizedBox(
            width: 80,
            child: Text(
              'Згненрувати штрихкод',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall!
                  .copyWith(color: Colors.white, fontSize: 13),
            )),
      ),
    );
  }
}
