import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/home_page/cubit/home_page_cubit.dart';
import 'package:virok_wms/feature/inventory/inventory_data/cubit/inventory_data_cubit.dart';
import 'package:virok_wms/feature/inventory/models/doc.dart';
import 'package:virok_wms/feature/inventory/models/inventory.dart';
import 'package:virok_wms/ui/custom_keyboard/keyboard.dart';
import 'package:virok_wms/ui/theme/app_color.dart';
import 'package:virok_wms/ui/theme/app_theme.dart';
import 'package:virok_wms/ui/widgets/alerts.dart';
import 'package:virok_wms/ui/widgets/row_element.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';

class InventoryDataPage extends StatelessWidget {
  const InventoryDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryDataCubit(),
      child: const InventoryDataView(),
    );
  }
}

class InventoryDataView extends StatelessWidget {
  const InventoryDataView({super.key});

  @override
  Widget build(BuildContext context) {
    final argument =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final Doc doc = argument['doc'];
    return Scaffold(
      appBar: AppBar(
        title: Text(doc.docNumber),
        actions: [
          BlocBuilder<InventoryDataCubit, InventoryDataState>(
            builder: (context, state) {
              return IconButton(
                  onPressed: () {
                    addCellDialog(context, state.nom.docNumber);
                  },
                  icon: const Icon(Icons.add, size: 30,));
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          children: [
            _BarcodeInput(
              docNumber: doc.docNumber,
            ),
            const SizedBox(
              width: 5,
            ),
            const SizedBox(
              height: 8,
            ),
            const _NomInfo(),
            const SizedBox(
              height: 8,
            ),
            const _CellsTable(),
          ],
        ),
      ),
    );
  }
}

class _BarcodeInput extends StatefulWidget {
  const _BarcodeInput({required this.docNumber});

  final String docNumber;

  @override
  State<_BarcodeInput> createState() => _BarcodeInputState();
}

class _BarcodeInputState extends State<_BarcodeInput> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final bool cameraScaner = context.read<HomePageCubit>().state.cameraScaner;

    return TextField(
      autofocus: cameraScaner ? false : true,
      focusNode: focusNode,
      controller: controller,
      onSubmitted: (value) {
        context.read<InventoryDataCubit>().getNom(value, widget.docNumber);
        controller.clear();
        focusNode.requestFocus();
      },
      decoration: InputDecoration(
          hintText: 'Відскануйте штрихкод',
          suffixIcon: cameraScaner
              ? CameraScanerButton(
                  scan: (value) {
                    context
                        .read<InventoryDataCubit>()
                        .getNom(value, widget.docNumber);
                  },
                )
              : null),
    );
  }
}

class _NomInfo extends StatelessWidget {
  const _NomInfo();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InventoryDataCubit, InventoryDataState>(
      listener: (context, state) {
        if (state.status.isNotFound) {
          Alerts(msg: state.errorMassage, context: context).showError();
        }
      },
      builder: (context, state) {
        return BlocBuilder<InventoryDataCubit, InventoryDataState>(
          builder: (context, state) {
            if (state.status.isLoading) {
              return const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return Text(state.nom.nom);
          },
        );
      },
    );
  }
}

class _TableHead extends StatelessWidget {
  const _TableHead();

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleSmall;

    return TableHeads(
      children: [
        RowElement(
          flex: 4,
          value: 'Комірка',
          textStyle: textStyle,
        ),
        RowElement(
          flex: 1,
          value: 'К-ть',
          textStyle: textStyle,
        ),
        RowElement(
          flex: 1,
          value: 'Скан.',
          textStyle: textStyle,
        ),
      ],
    );
  }
}

class _CellsTable extends StatelessWidget {
  const _CellsTable();

  @override
  Widget build(BuildContext context) {
    final MyColors myColors = Theme.of(context).extension<MyColors>()!;
    return BlocBuilder<InventoryDataCubit, InventoryDataState>(
      builder: (context, state) {
        final cells = state.nom.cells;
        if (state.status.isInitial) {
          return const SizedBox();
        }
        if (state.status.isNotFound) {
          return const SizedBox();
        }

        return Expanded(
          child: Column(
            children: [
              const _TableHead(),
              Expanded(
                child: ListView.builder(
                    itemCount: cells.length,
                    itemBuilder: (context, index) {
                      return TableElement(
                        dataLenght: cells.length,
                        rowElement: [
                          RowElement(flex: 4, value: cells[index].cellName),
                          RowElement(
                              flex: 1,
                              value: cells[index].planCount.toString()),
                          RowElement(
                              flex: 1,
                              value: cells[index].factCount.toString()),
                        ],
                        index: index,
                        onTap: () {
                          showCountInputDialog(
                              context, state.nom, cells[index]);
                        },
                        color: index % 2 != 0
                            ? myColors.tableDarkColor
                            : myColors.tableLightColor,
                      );
                    }),
              ),
              // const SizedBox(
              //   height: 5,
              // ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(0, 2, 0, 6),
              //   child: FloatingActionButton(
              //     onPressed: () {
              //       addCellDialog(context, state.nom.docNumber);
              //     },
              //     child: const Icon(
              //       Icons.add,
              //       color: Colors.white,
              //     ),
              //   ),
              // )
            ],
          ),
        );
      },
    );
  }
}

showCountInputDialog(BuildContext context, Inventory nom, Cell cell) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => BlocProvider.value(
      value: context.read<InventoryDataCubit>(),
      child: _CountInputDialog(
        cell: cell,
        nom: nom,
      ),
    ),
  );
}

class _CountInputDialog extends StatefulWidget {
  const _CountInputDialog({required this.cell, required this.nom});

  final Inventory nom;
  final Cell cell;

  @override
  State<_CountInputDialog> createState() => _CountInputDialogState();
}

class _CountInputDialogState extends State<_CountInputDialog> {
  final cellController = TextEditingController();
  final nomController = TextEditingController();

  final cellFocusNode = FocusNode();
  final nomFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool cameraScaner = context.read<HomePageCubit>().state.cameraScaner;

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        context.read<InventoryDataCubit>().clear();
      },
      child: AlertDialog(
        iconPadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        actionsPadding: const EdgeInsets.only(bottom: 5),
        icon: DialogHead(
          article: widget.nom.article,
          onPressed: () {
            Navigator.pop(context);

            context.read<InventoryDataCubit>().clear();
          },
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.nom.nom,
              style: theme.textTheme.titleMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.dialogYellow),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Кількість:',
                      style: theme.textTheme.titleSmall!
                          .copyWith(color: Colors.black)),
                  Text(widget.cell.planCount.toString(),
                      style: theme.textTheme.titleSmall?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              autofocus: cameraScaner ? false : true,
              controller: cellController,
              focusNode: cellFocusNode,
              textInputAction: TextInputAction.next,
              onSubmitted: (value) {
                final res = context
                    .read<InventoryDataCubit>()
                    .scanCell(value, widget.cell);

                if (res == false) {
                  cellController.clear();
                  cellFocusNode.requestFocus();
                }
              },
              decoration: InputDecoration(
                  hintText: 'Відскануйте комірку',
                  suffixIcon: cameraScaner
                      ? CameraScanerButton(
                          scan: (value) {
                            context
                                .read<InventoryDataCubit>()
                                .scanCell(value, widget.cell);
                          },
                        )
                      : null),
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              focusNode: nomFocusNode,
              controller: nomController,
              onSubmitted: (value) {
                context.read<InventoryDataCubit>().scanNom(value, widget.nom);
                nomController.clear();
                nomFocusNode.requestFocus();
              },
              decoration: InputDecoration(
                  hintText: 'Відскануйте товар',
                  suffixIcon: cameraScaner
                      ? CameraScanerButton(
                          scan: (value) {
                            context
                                .read<InventoryDataCubit>()
                                .scanNom(value, widget.nom);
                          },
                        )
                      : null),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.dialogGreen),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Відскановано:',
                      style: theme.textTheme.titleSmall!
                          .copyWith(color: Colors.black)),
                  Text(widget.cell.factCount.toString(),
                      style: theme.textTheme.titleSmall?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                ],
              ),
            ),
            BlocBuilder<InventoryDataCubit, InventoryDataState>(
              builder: (context, state) {
                return FittedBox(
                  child: Text(
                    state.count.toString(),
                    style: const TextStyle(fontSize: 120),
                  ),
                );
              },
            )
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          BlocBuilder<InventoryDataCubit, InventoryDataState>(
            builder: (context, state) {
              return ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          state.nomBarcode.isEmpty &&
                                  cellController.text.isEmpty
                              ? Colors.grey
                              : Colors.green)),
                  onPressed: () {
                    final state = context.read<InventoryDataCubit>().state;
                    if (state.nomBarcode.isNotEmpty &&
                        cellController.text.isNotEmpty) {
                      showManualCountDialog(context);
                    }
                  },
                  child: const Text('Ввести вручну'));
            },
          ),
          ElevatedButton(
              onPressed: () {
                final state = context.read<InventoryDataCubit>().state;

                if (state.nomBarcode.isNotEmpty &&
                    cellController.text.isNotEmpty) {
                  context.read<InventoryDataCubit>().sendNom(state.nomBarcode,
                      state.count, widget.nom.docNumber, cellController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('Додати'))
        ],
      ),
    );
  }
}

showManualCountDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => BlocProvider.value(
      value: context.read<InventoryDataCubit>(),
      child: const MonualCountDialog(),
    ),
  );
}

class MonualCountDialog extends StatefulWidget {
  const MonualCountDialog({
    super.key,
  });

  @override
  State<MonualCountDialog> createState() => _MonualCountDialogState();
}

class _MonualCountDialogState extends State<MonualCountDialog> {
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
                  onChanged: (value) {},
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
                  context
                      .read<InventoryDataCubit>()
                      .manualCountIncrement(controller.text);
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

addCellDialog(BuildContext context, String docNumber) {
  showDialog(
    context: context,
    builder: (_) => BlocProvider.value(
      value: context.read<InventoryDataCubit>(),
      child: AddCellDialog(
        docNumber: docNumber,
      ),
    ),
  );
}

class AddCellDialog extends StatefulWidget {
  const AddCellDialog({super.key, required this.docNumber});

  final String docNumber;

  @override
  State<AddCellDialog> createState() => _AddCellDialogState();
}

class _AddCellDialogState extends State<AddCellDialog> {
  final cellController = TextEditingController();
  final nomController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final bool cameraScaner = context.read<HomePageCubit>().state.cameraScaner;

    return AlertDialog(
      iconPadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      icon: DialogHead(article: '', onPressed: () => Navigator.pop(context)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            autofocus: cameraScaner ? false : true,
            textInputAction: TextInputAction.next,
            controller: cellController,
            decoration: InputDecoration(
                hintText: 'Відскануйте комірку',
                suffixIcon: cameraScaner
                    ? CameraScanerButton(
                        scan: (value) {
                          cellController.text = value;
                        },
                      )
                    : null),
          ),
          const SizedBox(
            height: 5,
          ),
          TextField(
            controller: nomController,
            decoration: InputDecoration(
                hintText: 'Відскануйте товар',
                suffixIcon: cameraScaner
                    ? CameraScanerButton(
                        scan: (value) {
                          nomController.text = value;
                        },
                      )
                    : null),
          )
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
            onPressed: () {
              context.read<InventoryDataCubit>().addToCell(
                  nomController.text, widget.docNumber, cellController.text);
              Navigator.pop(context);
            },
            child: const Text('Додати'))
      ],
    );
  }
}
