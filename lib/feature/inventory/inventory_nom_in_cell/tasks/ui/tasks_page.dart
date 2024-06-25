import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:virok_wms/feature/inventory/inventory_nom_in_cell/tasks/cubit/inventory_nom_in_cell_cubit.dart';
import 'package:virok_wms/feature/inventory/inventory_nom_in_cell/tasks/ui/create_new_task_dialog.dart';
import 'package:virok_wms/feature/inventory/inventory_nom_in_cell/tasks/ui/nom_scan_dialog.dart';

import '../../../../../ui/ui.dart';

class InventoryNomInCellTasksPage extends StatelessWidget {
  const InventoryNomInCellTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryNomInCellCubit(),
      child: const InventoryNomInCellTasksView(),
    );
  }
}

class InventoryNomInCellTasksView extends StatelessWidget {
  const InventoryNomInCellTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Вибіркова інвентаризація',
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(
              onPressed: () {
                context.read<InventoryNomInCellCubit>().getTasks();
              },
              icon: const Icon(Icons.refresh)),
          IconButton(
              onPressed: () {
                createNEwTask(context);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<InventoryNomInCellCubit>().getTasks();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.grey[500],
                    size: 18,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Щоб завершити, перетяніть завдання вліво!!!',
                    style: theme.textTheme.titleSmall!
                        .copyWith(fontSize: 12, color: Colors.grey[500]),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const _TableHead(),
              _TableData(
                focusNode: focusNode,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _TableHead extends StatelessWidget {
  const _TableHead();

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 13);

    return TableHeads(
      children: [
        RowElement(
          flex: 1,
          value: '№',
          textStyle: textStyle,
        ),
        RowElement(
          flex: 4,
          value: 'Артикул',
          textStyle: textStyle,
        ),
        RowElement(
          flex: 5,
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
  const _TableData({required this.focusNode});

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final MyColors myColors = Theme.of(context).extension<MyColors>()!;
final theme = Theme.of(context);
    return BlocConsumer<InventoryNomInCellCubit, InventoryNomInCellState>(
      listener: (context, state) {
        if (state.status.isNotFound) {
          Alerts(msg: state.errorMassage, context: context).showError();
        }
      },
      builder: (context, state) {
        final tasks = state.tasks.tasks;

        if (state.status.isInitial) {
          context.read<InventoryNomInCellCubit>().getTasks();
          return const Expanded(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        }

        return Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) => Slidable(
              endActionPane: ActionPane(
                  extentRatio: 0.4,
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) {
                        showDialog(
                            context: context,
                            builder: (_) => BlocProvider.value(
                                  value:
                                      context.read<InventoryNomInCellCubit>(),
                                  child: YesOrNoDialog(
                                    massage:
                                        'Ви дійсно бажаєте завершити завдання?',
                                    noButton: () {
                                      Navigator.pop(context);
                                    },
                                    yesButton: () {
                                      context
                                          .read<InventoryNomInCellCubit>()
                                          .closeTask(tasks[index].taskNumber);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ));
                      },
                      backgroundColor: const Color.fromARGB(255, 229, 62, 62),
                      foregroundColor: Colors.white,
                      icon: Icons.check_sharp,
                      label: 'Завершити',
                    )
                  ]),
              child: TableElement(
                dataLenght: tasks.length,
                rowElement: [
                  RowElement(flex: 1, value: (index +1).toString()),
                  RowElement(flex: 4, value: tasks[index].article),
                  RowElement(flex: 5, value: tasks[index].nameCell, textStyle: theme.textTheme.titleSmall!.copyWith(fontSize: 12),),
                  RowElement(flex: 4, value: tasks[index].nomStatus),
                  RowElement(flex: 2, value: tasks[index].count.toString(),),
                  RowElement(
                      flex: 2, value: tasks[index].scannedCount.toString()),
                ],
                index: index,
                color: index % 2 != 0
                    ? myColors.tableDarkColor
                    : myColors.tableLightColor,
                onTap: () {
                  showInventoryNomInCellDialog(
                      context, tasks[index], focusNode);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

