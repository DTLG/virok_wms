import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/home_page/cubit/home_page_cubit.dart';
import 'package:virok_wms/feature/inventory/inventory_full/full_inventory_data/cubit/full_inventory_data_cubit.dart';
import 'package:virok_wms/feature/inventory/inventory_full/models/doc.dart';

import '../../../../../ui/ui.dart';
import '../../models/inventory.dart';


class FullInventoryDataPage extends StatelessWidget {
  const FullInventoryDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FullInventoryDataCubit(),
      child: const FullInventoryDataView(),
    );
  }
}

class FullInventoryDataView extends StatelessWidget {
  const FullInventoryDataView({super.key});

  @override
  Widget build(BuildContext context) {
    final argument =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final Doc doc = argument['doc'];
    return Scaffold(
      appBar: AppBar(
        title: Text(doc.docNumber),
        actions: [
          BlocBuilder<FullInventoryDataCubit, FullInventoryDataState>(
            builder: (context, state) {
              return IconButton(
                  onPressed: () {
                    addCellDialog(context, state.nom.docNumber);
                  },
                  icon: const Icon(
                    Icons.add,
                  ));
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
  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    final bool cameraScaner = context.read<HomePageCubit>().state.cameraScaner;
    if (_switchValue == false && cameraScaner) {
      focusNode.unfocus();
    }
    return TextField(
      autofocus: cameraScaner ? false : true,
      focusNode: focusNode,
      controller: controller,
      onSubmitted: (value) {
        if (value.contains(' ')) return;
        !_switchValue
            ? context
                .read<FullInventoryDataCubit>()
                .getNomByBarcode(value, widget.docNumber)
            : context
                .read<FullInventoryDataCubit>()
                .getNomByArticle(value, widget.docNumber);
        controller.clear();
        focusNode.requestFocus();
      },
      decoration: InputDecoration(
          hintText: _switchValue ? 'Введіть артикул' : 'Відскануйте штрихкод',
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              cameraScaner
                  ? CameraScanerButton(
                      scan: (value) {
                        context
                            .read<FullInventoryDataCubit>()
                            .getNomByBarcode(value, widget.docNumber);
                      },
                    )
                  : const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Switch(
                  value: _switchValue,
                  onChanged: (value) {
                    setState(() => _switchValue = value);
                  },
                ),
              ),
            ],
          )),
    );
  }
}

class _NomInfo extends StatelessWidget {
  const _NomInfo();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FullInventoryDataCubit, FullInventoryDataState>(
      listener: (context, state) {
        if (state.status.isNotFound) {
          Alerts(msg: state.errorMassage, context: context).showError();
        }
      },
      builder: (context, state) {
        return BlocBuilder<FullInventoryDataCubit, FullInventoryDataState>(
          builder: (context, state) {
            if (state.status.isLoading) {
              return const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (state.status.isInitial) {
              return const SizedBox();
            }
            if (state.status.isNotFound) {
              return const SizedBox();
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
          flex: 2,
          value: 'Стан',
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
    final theme = Theme.of(context);
    return BlocBuilder<FullInventoryDataCubit, FullInventoryDataState>(
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
                        bottomMargin: 60,
                        dataLenght: cells.length,
                        rowElement: [
                          RowElement(flex: 4, value: cells[index].cellName, textStyle: theme.textTheme.titleSmall,),
                          RowElement(flex: 2, value: cells[index].nomStatus),
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
      value: context.read<FullInventoryDataCubit>(),
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
        context.read<FullInventoryDataCubit>().clear();
      },
      child: AlertDialog(
        iconPadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        actionsPadding: const EdgeInsets.only(bottom: 5),
        icon: DialogHead(
          title: widget.nom.article,
          onPressed: () {
            Navigator.pop(context);

            context.read<FullInventoryDataCubit>().clear();
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
                  color: AppColors.dialogOrange),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Стан:',
                      style: theme.textTheme.titleSmall!
                          .copyWith(color: Colors.black)),
                  Text(widget.cell.nomStatus.toString(),
                      style: theme.textTheme.titleSmall?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                ],
              ),
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
                    .read<FullInventoryDataCubit>()
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
                                .read<FullInventoryDataCubit>()
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
                context.read<FullInventoryDataCubit>().scanNom(value, widget.nom);
                nomController.clear();
                nomFocusNode.requestFocus();
              },
              decoration: InputDecoration(
                  hintText: 'Відскануйте товар',
                  suffixIcon: cameraScaner
                      ? CameraScanerButton(
                          scan: (value) {
                            context
                                .read<FullInventoryDataCubit>()
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
            BlocBuilder<FullInventoryDataCubit, FullInventoryDataState>(
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
          BlocBuilder<FullInventoryDataCubit, FullInventoryDataState>(
            builder: (context, state) {
              return ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          state.nomBarcode.isEmpty &&
                                  cellController.text.isEmpty
                              ? Colors.grey
                              : Colors.green)),
                  onPressed: () {
                    final state = context.read<FullInventoryDataCubit>().state;
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
                final state = context.read<FullInventoryDataCubit>().state;

                if (state.nomBarcode.isNotEmpty &&
                    cellController.text.isNotEmpty) {
                  context.read<FullInventoryDataCubit>().sendNom(
                      state.nomBarcode,
                      state.count,
                      widget.nom.docNumber,
                      widget.cell.nomStatus,
                      cellController.text);
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
      value: context.read<FullInventoryDataCubit>(),
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
                      .read<FullInventoryDataCubit>()
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
      value: context.read<FullInventoryDataCubit>(),
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
  String initialValue = 'Статус';
  String nomStatus = '';
  @override
  void initState() {
    nomStatus = initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool cameraScaner = context.read<HomePageCubit>().state.cameraScaner;

    return AlertDialog(
      iconPadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      icon: DialogHead(title: '', onPressed: () => Navigator.pop(context)),
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
          ),
          const SizedBox(
            height: 5,
          ),
          PopupMenuButton(
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
                borderRadius: BorderRadius.all(Radius.circular(18.0))),
            child: Container(
              height: 50,
              width: 110,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 100, 100, 100)),
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
          const SizedBox(
            height: 10,
          )
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
            onPressed: () {
              if (nomController.text.isEmpty ||
                  cellController.text.isEmpty ||
                  nomStatus == initialValue) return;
              context.read<FullInventoryDataCubit>().addToCell(nomController.text,
                  widget.docNumber, cellController.text, nomStatus);
              Navigator.pop(context);
            },
            child: const Text('Додати'))
      ],
    );
  }
}
