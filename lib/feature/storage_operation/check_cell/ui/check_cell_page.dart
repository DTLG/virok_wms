import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/home_page/cubit/home_page_cubit.dart';
import 'package:virok_wms/feature/storage_operation/check_cell/cubit/check_cell_cubit.dart';
import 'package:virok_wms/feature/storage_operation/check_nom/models/barcodes_noms.dart';
import 'package:virok_wms/models/check_cell.dart';
import 'package:virok_wms/route/app_routes.dart';

import 'package:virok_wms/ui/widgets/widgets.dart';

import '../../../../ui/custom_keyboard/keyboard.dart';

class CheckCellPage extends StatelessWidget {
  const CheckCellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckCellCubit(),
      child: const CheckCellView(),
    );
  }
}

class CheckCellView extends StatelessWidget {
  const CheckCellView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Комірка'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(7),
              child: ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 91, 79, 179)),
                    maximumSize: MaterialStatePropertyAll(Size.fromWidth(90)),
                    padding: MaterialStatePropertyAll(EdgeInsets.all(10))),
                child: Text('Очистити',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: Colors.white)),
                onPressed: () {
                  context.read<CheckCellCubit>().clear();
                },
              ),
            )
          ],
        ),
        body: Column(
          children: [
            const BarcodeInput(),
            BlocConsumer<CheckCellCubit, CheckCellState>(
              listener: (context, state) {
                if (state.status.isNotFound) {
                  Alerts(msg: state.errorMassage, context: context).showError();
                }
              },
              buildWhen: (previous, current) => !current.status.isNotFound,
              builder: (context, state) {
                if (state.status.isSuccess) {
                  return Expanded(
                    child: CellInfo(
                      cell: state.cell,
                    ),
                  );
                }
                if (state.status.isFailure) {
                  return Expanded(
                    child: Center(
                        child: WentWrong(
                      errorDescription: state.errorMassage,
                      buttonTrue: false,
                    )),
                  );
                }
                if (state.status.isLoading) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return const Center();
              },
            )
          ],
        ),
      ),
    );
  }
}

class BarcodeInput extends StatefulWidget {
  const BarcodeInput({super.key});

  @override
  State<BarcodeInput> createState() => _BarcodeInputState();
}

class _BarcodeInputState extends State<BarcodeInput> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final state = context.select((CheckCellCubit cubit) => cubit.state);
    state.status.isInitial ? controller.clear() : controller;
    final bool cameraScaner = context.read<HomePageCubit>().state.cameraScaner;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: cameraScaner ? false : true,
        onSubmitted: (value) {
          context.read<CheckCellCubit>().getCell(value);
          controller.clear();
          focusNode.requestFocus();
        },
        decoration: InputDecoration(
          suffixIcon: cameraScaner
              ? CameraScanerButton(
                  scan: (value) {
                    context.read<CheckCellCubit>().getCell(value);
                  },
                )
              : null,
          hintText: 'Відскануйте штрихкод',
        ),
      ),
    );
  }
}

class CellInfo extends StatelessWidget {
  const CellInfo({super.key, required this.cell});

  final CheckCell cell;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Комірка',
                  style: theme.titleLarge,
                ),
                Text(cell.nameCell, style: theme.titleLarge)
              ],
            ),
          ),
          cell.noms.isEmpty
              ? Text(
                  'Комірка вільна',
                  style: theme.titleSmall,
                )
              : Expanded(
                  child: ListView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: cell.noms.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onLongPress: () async {
                        final cells = await context
                            .read<CheckCellCubit>()
                            .getNoms(cell.noms[index].article);

                        final nom = cell.noms[index];
                        if (context.mounted) {
                          Navigator.pushNamed(context, AppRoutes.checkNomPage,
                              arguments: {
                                'nom': BarcodesNom(
                                    name: nom.name,
                                    article: nom.article,
                                    barcodes: nom.barcodes
                                        .map((e) => Barcode(
                                            barcode: e.barcode,
                                            count: 1,
                                            ratio: e.ratio.toDouble()))
                                        .toList(),
                                    cells: cells),
                              });
                        }
                      },
                      onTap: () {
                        restCountDialog(
                            context,
                            cell.codCell,
                            cell.noms[index].barcodes.isEmpty
                                ? ''
                                : cell.noms[index].barcodes.first.barcode);
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 3, vertical: 10),
                                child: Text(cell.noms[index].name,
                                    style: theme.titleMedium),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Артикул:', style: theme.titleSmall),
                                    Text(cell.noms[index].article,
                                        style: theme.titleSmall)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Кількість в комірці:',
                                        style: theme.titleSmall),
                                    Text(cell.noms[index].qty.toString(),
                                        style: theme.titleSmall)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Мінімальний залишок:',
                                        style: theme.titleSmall),
                                    Text(cell.noms[index].minRest.toString(),
                                        style: theme.titleSmall)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ))
        ],
      ),
    );
  }
}

restCountDialog(BuildContext context, String codCell, String nomBarcode) {
  showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
            value: context.read<CheckCellCubit>(),
            child: InputCountAlert(codCell: codCell, nomBarcode: nomBarcode),
          ));
}

class InputCountAlert extends StatefulWidget {
  const InputCountAlert(
      {super.key, required this.codCell, required this.nomBarcode});

  final String codCell;
  final String nomBarcode;
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
                  keyboardType: TextInputType.number,
                  autofocus: true,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Введіть мінімальний залишок в комірці',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              )
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
                onPressed: () {
                  if (controller.text.isEmpty) return;
                  context.read<CheckCellCubit>().setMinRest(
                      widget.codCell, controller.text, widget.nomBarcode);
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
