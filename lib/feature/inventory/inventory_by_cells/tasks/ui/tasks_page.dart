import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/home_page/cubit/home_page_cubit.dart';
import 'package:virok_wms/feature/inventory/inventory_by_cells/models/task.dart';
import 'package:virok_wms/feature/inventory/inventory_by_cells/tasks/cubit/inventory_by_cells_tasks_cubit.dart';
import 'package:virok_wms/route/app_routes.dart';

import '../../../../../ui/ui.dart';

class InventoryByCellsTasksPage extends StatelessWidget {
  const InventoryByCellsTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryByCellsTasksCubit(),
      child: const InventoryByCellsTasksView(),
    );
  }
}

class InventoryByCellsTasksView extends StatelessWidget {
  const InventoryByCellsTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Інвентаризація по комірках',
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(
              onPressed: () {
                createNewTasksdialog(context, focusNode);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<InventoryByCellsTasksCubit>().getTasks();
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
    final textStyle = Theme.of(context).textTheme.titleSmall;

    return TableHeads(
      children: [
        RowElement(
          flex: 1,
          value: '№',
          textStyle: textStyle,
        ),
        RowElement(
          flex: 3,
          value: '№ завдання',
          textStyle: textStyle,
        ),
        RowElement(
          flex: 3,
          value: 'Комірка',
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
    return BlocConsumer<InventoryByCellsTasksCubit, InventoryByCellsTasksState>(
      listener: (context, state) {
        if (state.status.isNotFound) {
          Alerts(msg: state.errorMassage, context: context).showError();
        }
      },
      builder: (context, state) {
        final tasks = state.tasks.inventoryTasks;

        if (state.status.isInitial) {
          context.read<InventoryByCellsTasksCubit>().getTasks();
          return const Expanded(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        }

        return Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) => TableElement(
              bottomMargin: 60,
              dataLenght: tasks.length,
              rowElement: [
                RowElement(flex: 1, value: (index + 1).toString()),
                RowElement(flex: 3, value: tasks[index].taskNumber),
                RowElement(
                  flex: 3,
                  value: tasks[index].nameCell,
                  textStyle: theme.textTheme.titleSmall!.copyWith(fontSize: 12),
                ),
              ],
              index: index,
              color: index % 2 != 0
                  ? myColors.tableDarkColor
                  : myColors.tableLightColor,
              onTap: () {
                Navigator.pushNamed(
                    context, AppRoutes.inventoryByCellsTaskNomsPage,
                    arguments: {
                      'tasksCubit': context.read<InventoryByCellsTasksCubit>(),
                      'task': tasks[index]
                    });
                focusNode.requestFocus();
              },
            ),
          ),
        );
      },
    );
  }
}

createNewTasksdialog(BuildContext context, FocusNode focusNode) {
  showDialog(
    context: context,
    builder: (_) => BlocProvider.value(
      value: context.read<InventoryByCellsTasksCubit>(),
      child: const NewTaskDialog(),
    ),
  );
  focusNode.requestFocus();
}

class NewTaskDialog extends StatefulWidget {
  const NewTaskDialog({super.key});

  @override
  State<NewTaskDialog> createState() => _NewTaskDialogState();
}

class _NewTaskDialogState extends State<NewTaskDialog> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bool cameraScaner = context.read<HomePageCubit>().state.cameraScaner;

    return AlertDialog(
      iconPadding: EdgeInsets.zero,
      icon: DialogHead(title: '', onPressed: () => Navigator.pop(context)),
      content: TextField(
        autofocus: cameraScaner ? false : true,
        controller: controller,
        decoration: InputDecoration(
          hintText: "Відскануйте комірку",
          suffixIcon: cameraScaner
              ? CameraScanerButton(
                  scan: (value) {
                    controller.text = value;
                  },
                )
              : const SizedBox(),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
            onPressed: () {
              if (controller.text.isEmpty) return;
              context
                  .read<InventoryByCellsTasksCubit>()
                  .newTasks(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Створити'))
      ],
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
        autofocus: cameraScaner ? false : true,
        controller: controller,
        focusNode: widget.focusNode,
        textAlignVertical: TextAlignVertical.bottom,
        onSubmitted: searchTask,
        decoration: InputDecoration(
            hintText: 'Відскануйте комірку',
            suffixIcon:
                cameraScaner ? CameraScanerButton(scan: searchTask) : null),
      ),
    );
  }

  searchTask(String value) {
    if (value.isEmpty) return;
    final task = context.read<InventoryByCellsTasksCubit>().searchTask(value);
    if (task != InventoryByCellsTask.empty) {
      Navigator.pushNamed(context, AppRoutes.inventoryByCellsTaskNomsPage,
          arguments: {
            'tasksCubit': context.read<InventoryByCellsTasksCubit>(),
            'task': task
          });
    }
    controller.clear();
    widget.focusNode.requestFocus();
  }
}
