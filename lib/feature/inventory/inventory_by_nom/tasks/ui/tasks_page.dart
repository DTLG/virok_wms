import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/home_page/cubit/home_page_cubit.dart';
import 'package:virok_wms/feature/inventory/inventory_by_nom/tasks/cubit/inventory_by_nom_tasks_cubit.dart';

import 'package:virok_wms/route/app_routes.dart';

import '../../../../../ui/ui.dart';
import '../../models/task.dart';

class InventoryByNomTasksPage extends StatelessWidget {
  const InventoryByNomTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryByNomTasksCubit(),
      child: const InventoryByNomTasksView(),
    );
  }
}

class InventoryByNomTasksView extends StatelessWidget {
  const InventoryByNomTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Інвентаризація номенклатури',
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<InventoryByNomTasksCubit>().getTasks();
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
          value: 'Артикул',
          textStyle: textStyle,
        ),
         RowElement(
          flex: 3,
          value: 'Дата',
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

    return BlocConsumer<InventoryByNomTasksCubit, InventoryByNomTasksState>(
      listener: (context, state) {
        if (state.status.isNotFound) {
          Alerts(msg: state.errorMassage, context: context).showError();
        }
      },
      builder: (context, state) {
        final tasks = state.tasks.tasks;

        if (state.status.isInitial) {
          context.read<InventoryByNomTasksCubit>().getTasks();
          return const Expanded(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        }

        return Expanded(
          child: ListView.builder(
            
            itemCount: tasks.length,
            itemBuilder: (context, index) => TableElement(              bottomMargin: 60,

              dataLenght: tasks.length,
              rowElement: [
                RowElement(flex: 1, value: (index + 1).toString()),
                RowElement(flex: 3, value: tasks[index].docNumber),
                RowElement(flex: 3, value: tasks[index].article),
                RowElement(flex: 3, value: tasks[index].date),
              ],
              index: index,
              color: index % 2 != 0
                  ? myColors.tableDarkColor
                  : myColors.tableLightColor,
              onTap: () {
                Navigator.pushNamed(
                    context, AppRoutes.inventoryByNomTaskPage,
                    arguments: {
                      'tasksCubit': context.read<InventoryByNomTasksCubit>(),
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
          hintText: 'Відскануйте штрихкод',
          suffixIcon:
          cameraScaner ? CameraScanerButton(scan: searchTask) : null
        ),
      ),
    );
  }

  searchTask(String value) {
    if (value.isEmpty) return;
    final task = context.read<InventoryByNomTasksCubit>().searchTask(value);
    if (task != InventoryByNomTask.empty) {
      Navigator.pushNamed(context, AppRoutes.inventoryByNomTaskPage,
          arguments: {
            'tasksCubit': context.read<InventoryByNomTasksCubit>(),
            'task': task
          });
    }
    controller.clear();
    widget.focusNode.requestFocus();
  }
}
