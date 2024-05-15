import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/home_page/cubit/home_page_cubit.dart';
import 'package:virok_wms/feature/inventory/inventory_by_cells/models/task.dart';
import 'package:virok_wms/feature/inventory/inventory_by_cells/models/task_noms.dart';
import 'package:virok_wms/feature/inventory/inventory_by_cells/task_noms/cubit/task_noms_cubit.dart';
import 'package:virok_wms/feature/inventory/inventory_by_cells/task_noms/ui/add_nom_dialog.dart';
import 'package:virok_wms/feature/inventory/inventory_by_cells/task_noms/ui/nom_scan_dialog.dart';
import 'package:virok_wms/feature/inventory/inventory_by_cells/tasks/cubit/inventory_by_cells_tasks_cubit.dart';

import '../../../../../ui/ui.dart';

class InventoryByCellsTaskNomsPage extends StatelessWidget {
  const InventoryByCellsTaskNomsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryByCellsTaskNomsCubit(),
      child: const InventoryByCellsTaskNomsView(),
    );
  }
}

class InventoryByCellsTaskNomsView extends StatefulWidget {
  const InventoryByCellsTaskNomsView({super.key});

  @override
  State<InventoryByCellsTaskNomsView> createState() =>
      _InventoryByCellsTaskNomsViewState();
}

class _InventoryByCellsTaskNomsViewState
    extends State<InventoryByCellsTaskNomsView> {
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    final InventoryByCellsTasksCubit tasksCubit = arguments['tasksCubit'];
    final InventoryByCellsTask task = arguments['task'];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              tasksCubit.getTasks();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: Text(
          task.nameCell,
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(
              onPressed: () {
                addNomDialog(context, task.taskNumber, focusNode, task.codeCell);
              },
              icon: const Icon(Icons.add)),
          IconButton(
              onPressed: () {
                context
                    .read<InventoryByCellsTaskNomsCubit>()
                    .getNoms(task.taskNumber);
                focusNode.requestFocus();
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context
              .read<InventoryByCellsTaskNomsCubit>()
              .getNoms(task.taskNumber);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _BarcodeInput(focusNode: focusNode),

              const SizedBox(
                height: 8,
              ),
              const _TableHead(),
              _TableData(
                taskNumber: task.taskNumber,
                focusNode: focusNode,
              )
            ],
          ),
        ),
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GeneralButton(
              lable: 'Завершити',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => YesOrNoDialog(
                    massage: "Ви дійсно бажаєте завершити завдання?",
                    noButton: () {
                      Navigator.pop(context);
                    },
                    yesButton: () {
                      tasksCubit.closeTask(task.taskNumber);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                );
                focusNode.requestFocus();
              })
        ],
      ),
    );
  }
}


class _TableHead extends StatelessWidget {
  const _TableHead();

  @override
  Widget build(BuildContext context) {
    final textStyle =
        Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 13);

    return TableHeads(
      children: [
        RowElement(
          flex: 2,
          value: '№',
          textStyle: textStyle,
        ),
        RowElement(
          flex: 6,
          value: 'Назва',
          textStyle: textStyle,
        ),
        RowElement(
          flex: 4,
          value: 'Артикул',
          textStyle: textStyle,
        ),
        RowElement(
          flex: 3,
          value: 'Стан',
          textStyle: textStyle,
        ),
        RowElement(
          flex: 2,
          value: 'К-ть',
          textStyle: textStyle,
        ),
        RowElement(
          flex: 2,
          value: 'Скан.',
          textStyle: textStyle,
        ),
      ],
    );
  }
}

class _TableData extends StatelessWidget {
  const _TableData({required this.taskNumber, required this.focusNode});

  final String taskNumber;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final MyColors myColors = Theme.of(context).extension<MyColors>()!;
    final theme = Theme.of(context);
    return BlocConsumer<InventoryByCellsTaskNomsCubit,
        InventoryByCellsTaskNomsState>(
      listener: (context, state) {
        if (state.status.isNotFound) {
          Alerts(msg: state.errorMassage, context: context).showError();
        }
      },
      builder: (context, state) {
        final noms = state.noms.cellInventoryTaskData;

        if (state.status.isInitial) {
          context.read<InventoryByCellsTaskNomsCubit>().getNoms(taskNumber);
          return const Expanded(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        }

        return Expanded(
          child: ListView.builder(
            itemCount: noms.length,
            itemBuilder: (context, index) => TableElement(
              bottomMargin: 60,
              dataLenght: noms.length,
              rowElement: [
                RowElement(
                  flex: 2,
                  value: (index + 1).toString(),
                ),
                RowElement(
                    flex: 6,
                    value: noms[index].nom,
                    textStyle: theme.textTheme.labelSmall?.copyWith(
                        letterSpacing: 0.5,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 9)),
                RowElement(
                    flex: 4,
                    value: noms[index].article,
                    textStyle: theme.textTheme.labelMedium
                        ?.copyWith(fontWeight: FontWeight.w500, fontSize: 10)),
                RowElement(
                    flex: 3,
                    value: noms[index].nomStatus,
                    textStyle: theme.textTheme.labelMedium),
                RowElement(
                    flex: 2,
                    value: noms[index].count.toString(),
                    textStyle: theme.textTheme.labelMedium),
                RowElement(
                    flex: 2,
                    value: noms[index].scannedCount.toString(),
                    textStyle: theme.textTheme.labelMedium),
              ],
              index: index,
              color: index % 2 != 0
                  ? myColors.tableDarkColor
                  : myColors.tableLightColor,
              onTap: () {
                showInventoryByCellsNomScanDialog(
                    context, noms[index], focusNode);
              },
            ),
          ),
        );
      },
    );
  }
}

class _BarcodeInput extends StatefulWidget {
  const _BarcodeInput({required this.focusNode});
  final FocusNode focusNode;

  @override
  State<_BarcodeInput> createState() => _BarcodeInputState();
}

class _BarcodeInputState extends State<_BarcodeInput> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final bool cameraScaner = context.read<HomePageCubit>().state.cameraScaner;
    return SizedBox(
      height: 50,
      child: TextField(
        autofocus: true,
        controller: controller,
        focusNode: widget.focusNode,
        textAlignVertical: TextAlignVertical.bottom,
        onSubmitted: (value) {
          if (value.isEmpty) return;
          final nom =
              context.read<InventoryByCellsTaskNomsCubit>().searchNom(value);
          if (nom != CellInventoryTaskNom.empty) {
            showInventoryByCellsNomScanDialog(context, nom, widget.focusNode);
          }
          controller.clear();
          widget.focusNode.requestFocus();
        },
        decoration: InputDecoration(
            hintText: 'Відскануйте штрихкод',
            suffixIcon: cameraScaner
                ? CameraScanerButton(
                    scan: (value) {
                      final nom = context
                          .read<InventoryByCellsTaskNomsCubit>()
                          .searchNom(value);

                      if (nom != CellInventoryTaskNom.empty) {
                        showInventoryByCellsNomScanDialog(
                            context, nom, widget.focusNode);
                      }
                    },
                  )
                : null),
      ),
    );
  }
}
