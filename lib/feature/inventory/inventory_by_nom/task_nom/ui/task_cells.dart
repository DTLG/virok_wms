import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/inventory/inventory_by_nom/models/task.dart';
import 'package:virok_wms/feature/inventory/inventory_by_nom/task_nom/cubit/task_nom_cubit.dart';
import 'package:virok_wms/feature/inventory/inventory_by_nom/task_nom/ui/add_cell_dialog.dart';
import 'package:virok_wms/feature/inventory/inventory_by_nom/task_nom/ui/nom_scan_dialog.dart';
import 'package:virok_wms/feature/inventory/inventory_by_nom/tasks/cubit/inventory_by_nom_tasks_cubit.dart';

import '../../../../../ui/ui.dart';

class InventoryByNomTaskCellsPage extends StatelessWidget {
  const InventoryByNomTaskCellsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryByNomCellsTaskCubit(),
      child: const InventoryByNomTaskCellsView(),
    );
  }
}

class InventoryByNomTaskCellsView extends StatefulWidget {
  const InventoryByNomTaskCellsView({super.key});

  @override
  State<InventoryByNomTaskCellsView> createState() =>
      _InventoryByCellsTaskNomsViewState();
}

class _InventoryByCellsTaskNomsViewState
    extends State<InventoryByNomTaskCellsView> {
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    final InventoryByNomTasksCubit tasksCubit = arguments['tasksCubit'];
    final InventoryByNomTask task = arguments['task'];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              tasksCubit.getTasks();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: Text(
          task.article,
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(
              onPressed: () {
                addCellDialog(context, task.docNumber, focusNode);
              },
              icon: const Icon(Icons.add)),
          IconButton(
              onPressed: () {
                context.read<InventoryByNomCellsTaskCubit>().getCells(task);

                focusNode.requestFocus();
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<InventoryByNomCellsTaskCubit>().getCells(task);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<InventoryByNomCellsTaskCubit,
              InventoryByNomCellsTaskState>(
            builder: (context, state) {
              if (state.status.isFailure) {
                return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 60),
                      child: WentWrong(
                                        errorDescription: state.errorMassage,
                                        onPressed: () {
                      context.read<InventoryByNomCellsTaskCubit>().getCells(task);
                                        },
                                      ),
                    ));
              }

              return Column(
                children: [
                  Text(state.cells.nom),
                  const SizedBox(
                    height: 8,
                  ),
                  const _TableHead(),
                  _TableData(
                    task: task,
                    focusNode: focusNode,
                  )
                ],
              );
            },
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
                      massage: 'Ви дійсно бажаєте завершити завдання?',
                      yesButton: () {
                        tasksCubit.closeTask(task.docNumber);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      noButton: () {
                        Navigator.pop(context);
                      }),
                );
                focusNode.requestFocus();

                // showClosingCheck(
                //   context,
                //   'Ви дійсно бажаєте завершити завдання?',
                //   focusNode,
                //   yesButton: () {
                //     tasksCubit.closeTask(task.docNumber);
                //     Navigator.pop(context);
                //     Navigator.pop(context);
                //   },
                //   noButton: () {
                //     Navigator.pop(context);
                //   },
                // );
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
          value: 'Комірка',
          textStyle: textStyle,
        ),
        RowElement(
          flex: 4,
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
  const _TableData({required this.task, required this.focusNode});

  final InventoryByNomTask task;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final MyColors myColors = Theme.of(context).extension<MyColors>()!;
    final theme = Theme.of(context);
    return BlocConsumer<InventoryByNomCellsTaskCubit,
        InventoryByNomCellsTaskState>(
      listener: (context, state) {
        if (state.status.isNotFound) {
          Alerts(msg: state.errorMassage, context: context).showError();
        }
      },
      builder: (context, state) {
        final nomData = state.cells;

        if (state.status.isInitial) {
          context.read<InventoryByNomCellsTaskCubit>().getCells(task);
          return const Expanded(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        }

        return Expanded(
          child: ListView.builder(
            itemCount: nomData.cells.length,
            itemBuilder: (context, index) => TableElement(              bottomMargin: 60,

              dataLenght: nomData.cells.length,
              rowElement: [
                RowElement(
                  flex: 2,
                  value: (index + 1).toString(),
                ),
                RowElement(
                    flex: 6,
                    value: nomData.cells[index].name,
                    textStyle: theme.textTheme.titleSmall),
                RowElement(
                    flex: 4,
                    value: nomData.cells[index].nomStatus,
                    textStyle: theme.textTheme.titleSmall),
                RowElement(
                    flex: 2,
                    value: nomData.cells[index].planCount.toString(),
                    textStyle: theme.textTheme.titleSmall),
                RowElement(
                    flex: 2,
                    value: nomData.cells[index].factCount.toString(),
                    textStyle: theme.textTheme.titleSmall),
              ],
              index: index,
              color: index % 2 != 0
                  ? myColors.tableDarkColor
                  : myColors.tableLightColor,
              onTap: () {
                showInventoryByNomCellScanDialog(
                    context, nomData, index, focusNode);
              },
            ),
          ),
        );
      },
    );
  }
}
