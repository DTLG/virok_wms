import 'package:animations/animations.dart';
// ignore: library_prefixes
import 'package:barcode_widget/barcode_widget.dart' as barcodeWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:virok_wms/feature/home_page/cubit/home_page_cubit.dart';
import 'package:virok_wms/feature/storage_operation/check_nom/cubit/check_nom_list_cubit.dart';
import 'package:virok_wms/feature/storage_operation/check_nom/models/barcodes_noms.dart';
import 'package:virok_wms/ui/custom_keyboard/keyboard.dart';
import 'package:virok_wms/ui/theme/app_color.dart';

import 'package:virok_wms/ui/widgets/widgets.dart';

import '../cubit/nom_operations_cubit.dart';

class CheckNomPage extends StatelessWidget {
  const CheckNomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NomOperationsCubit(),
      child: const CheckNomView(),
    );
  }
}

class CheckNomView extends StatelessWidget {
  const CheckNomView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.select((NomOperationsCubit cubit) => cubit.state);

    final bool barcodeGenerationButton = state.barcodeGenerationButton;

    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final nom = arguments['nom'] as BarcodesNom;
    final nomslistCubit = arguments['nomsListCubit'] as CheckNomListCubit;
    final searchValue = arguments['searchValue'] as String;
    final query = arguments["query"] as String;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              nomslistCubit.getNoms(query, searchValue);
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
                  Alerts(msg: state.errorMassage, context: context).showError();
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
            Expanded(
              child: CellsCard(
                nom: nom,
              ),
            )
          ],
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
          color: theme.cardColor, borderRadius: BorderRadius.circular(20)),
      height: nom.barcodes.length > 5
          ? 225
          : nom.barcodes.isEmpty
              ? 40
              : 30 + (nom.barcodes.length * 40),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          nom.barcodes.isNotEmpty
              ? Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Штрихкод (${nom.barcodes.length})'),
                          const Text('Коефіцієнт'),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: ListView.separated(
                        itemCount: nom.barcodes.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onLongPress: () {
                              showBarcodeCard(
                                  context,
                                  nom.barcodes[index].barcode,
                                  nom.barcodes[index].barcode.length == 13
                                      ? barcodeWidget.Barcode.ean13()
                                      : nom.barcodes[index].barcode.length == 14
                                          ? barcodeWidget.Barcode.itf()
                                          : barcodeWidget.Barcode.code128());
                            },
                            onTap: () {
                              barcodeLablePrintButton
                                  ? showPrintAlertAlert(
                                      context,
                                      nom,
                                      nom.barcodes[index].barcode,
                                    )
                                  : () {};
                            },
                            child: Slidable(
                              startActionPane: ActionPane(
                                  extentRatio: 0.38,
                                  motion: const DrawerMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (_) {
                                        deleteBarcodeDialog(context,
                                            nom.barcodes[index], nom.article);
                                      },
                                      backgroundColor: const Color.fromARGB(
                                          255, 229, 62, 62),
                                      foregroundColor: Colors.white,
                                      label: 'Видалити',
                                    )
                                  ]),
                              child: SizedBox(
                                height: 35,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(nom.barcodes[index].barcode,
                                        style: theme.textTheme.titleSmall!
                                            .copyWith(fontSize: 13)),
                                    const Spacer(),
                                    Text(nom.barcodes[index].ratio.toString(),
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
          color: theme.cardColor, borderRadius: BorderRadius.circular(20)),
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
                    SizedBox(
                        width: 120,
                        child: Text('Комірка (${nom.cells.length})')),
                    const Text('Cтатус'),
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
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 150,
                            child: Text(nom.cells[index].nameCell,
                                maxLines: 2, style: theme.textTheme.titleSmall),
                          ),
                          Text(nom.cells[index].nomStatus,
                              style: theme.textTheme.titleSmall),
                          SizedBox(
                            width: 50,
                            child: Text(
                              nom.cells[index].count.toStringAsFixed(0),
                              style: theme.textTheme.titleSmall,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(
                    height: 0,
                  ),
                )),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Загальна сума:', style: theme.textTheme.titleSmall),
                    Text(nom.totalCount.toString(),
                        style: theme.textTheme.titleSmall),
                  ],
                )
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
    final bool cameraScaner = context.read<HomePageCubit>().state.cameraScaner;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AlertDialog(
        insetPadding: const EdgeInsets.all(0),
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
            SizedBox(
              height: 45,
              child: TextField(
                autofocus: cameraScaner ? false : true,
                controller: controller,
                focusNode: focusNode,
                onSubmitted: (value) {
                  focusNode.nextFocus();
                },
                textAlignVertical: TextAlignVertical.bottom,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    hintText: 'Згенерувати штрихкод',
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        cameraScaner
                            ? CameraScanerButton(
                                scan: (value) {
                                  controller.text = value;
                                },
                              )
                            : const SizedBox(),
                        GenerationButoon(
                          controller: controller,
                        ),
                        const SizedBox(
                          width: 5,
                        )
                      ],
                    )),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _switchValue
                ? const SizedBox()
                : SizedBox(
                    height: 45,
                    child: TextField(
                      autofocus: true,
                      textAlignVertical: TextAlignVertical.bottom,
                      controller: ratioController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Кратність',
                      ),
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
                for (var bar in widget.nom.barcodes) {
                  if (bar.barcode == controller.text) {
                    barThisNom = true;
                  }
                }
                if (barThisNom) {
                  Alerts(msg: "Штрихкод вже існує", context: context)
                      .showError();
                  return;
                }
                if (widget.nom.article.isEmpty) {
                  Alerts(msg: "Відсутній артикул", context: context)
                      .showError();
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
      ),
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
    return IconButton(
        alignment: const Alignment(2, 0),
        constraints: const BoxConstraints(),
        padding: EdgeInsets.zero,
        onPressed: () {
          final DateTime now = DateTime.now();

          String genBar = now.millisecondsSinceEpoch
              .toString()
              .replaceFirst(RegExp(r'1'), '', 0);
          controller.text = genBar.checkDigitCalculation;
        },
        icon: const Icon(
          Icons.add,
        ));
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

showPrintAlertAlert(BuildContext context, BarcodesNom nom, String barcode) {
  showDialog(
    context: context,
    builder: (_) {
      return BlocProvider.value(
        value: context.read<NomOperationsCubit>(),
        child: PrintAlert(
          nom: nom,
          barcode: barcode,
        ),
      );
    },
  );
}

class PrintAlert extends StatefulWidget {
  const PrintAlert({
    super.key,
    required this.nom,
    required this.barcode,
  });

  final BarcodesNom nom;
  final String barcode;

  @override
  State<PrintAlert> createState() => _PrintAlertState();
}

class _PrintAlertState extends State<PrintAlert> {
  final controller = TextEditingController();
  bool countButton = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        countButton ? const Spacer() : const SizedBox(),
        AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.nom.name,
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
                        child: Text(widget.nom.article,
                            textAlign: TextAlign.end,
                            style: theme.textTheme.titleSmall!
                                .copyWith(fontSize: 18)))
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
                      child: Text(widget.barcode,
                          textAlign: TextAlign.end,
                          style: theme.textTheme.titleSmall!
                              .copyWith(fontSize: 18)),
                    ),
                  ],
                ),
              ),
              countButton
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 60,
                          child: TextField(
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20),
                            controller: controller,
                            autofocus: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r"[1-90]"))
                            ],
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text('Введіть кількість'),
                      ],
                    )
                  : const SizedBox()
            ],
          ),
          contentPadding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
                onPressed: () {
                  controller.clear();
                  countButton = countButton == false ? true : false;
                  setState(() {});
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.grey)),
                child: const SizedBox(
                  height: 50,
                  width: 95,
                  child: Center(
                    child: Text(
                      'Кількість',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )),
            ElevatedButton(
                onPressed: () {
                  int count = controller.text.isEmpty
                      ? 1
                      : int.parse(
                          controller.text.isEmpty ? '1' : controller.text);

                  if (count > 99) {
                    Alerts(
                            msg: 'Максимальна кількість друку 99',
                            context: context)
                        .showError();
                    return;
                  }
                  context
                      .read<NomOperationsCubit>()
                      .printLable(widget.nom, widget.barcode, count);
                  Navigator.pop(context);
                },
                child: const SizedBox(
                  height: 50,
                  width: 95,
                  child: Center(
                    child: Text(
                      'Друк',
                      style: TextStyle(fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ))
          ],
        ),
        countButton ? Keyboard(controller: controller) : const SizedBox()
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

showBarcodeCard(BuildContext context, String data, barcodeWidget.Barcode type) {
  showModal(
    configuration: const FadeScaleTransitionConfiguration(),
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.white,
      title: barcodeWidget.BarcodeWidget(
        data: data,
        barcode: type,
        color: Colors.black,
        style: const TextStyle(color: Colors.black),
      ),
    ),
  );
}

deleteBarcodeDialog(BuildContext context, Barcode barcode, String article) {
  showModal(
    context: context,
    builder: (_) => BlocProvider.value(
      value: context.read<NomOperationsCubit>(),
      child: YesOrNoDialog(
          massage: 'Ви дійсно хочете видалити штрихкод - ${barcode.barcode}',
          noButton: () {
            Navigator.pop(context);
          },
          yesButton: () {
            context
                .read<NomOperationsCubit>()
                .deleteBarcdoe(barcode.barcode, article);
            Navigator.pop(context);
          }),
    ),
  );
}
