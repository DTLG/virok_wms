// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:virok_wms/feature/storage_operation/placement_writing_off/check_cell/cubit/check_cell_cubit.dart';
import 'package:virok_wms/feature/storage_operation/placement_writing_off/placement_writeing_off_repository/model/cell_model.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';

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
    return Scaffold(
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
          BlocBuilder<CheckCellCubit, CheckCellState>(
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
                return Expanded(
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return const Center();
            },
          )
        ],
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: true,
        onSubmitted: (value) {
          context.read<CheckCellCubit>().getCell(value);
          controller.clear();
          focusNode.requestFocus();
        },
        decoration: const InputDecoration(
          hintText: 'Відскануйте штрихкод',
        ),
      ),
    );
  }
}

class CellInfo extends StatelessWidget {
  const CellInfo({super.key, required this.cell});

  final Cell cell;

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
                Text(cell.cell.first.nameCell, style: theme.titleLarge)
              ],
            ),
          ),
          cell.cell.first.name.isEmpty
              ? const Text('')
              : Expanded(
                  child: ListView.builder(
                  itemCount: cell.cell.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: const Color.fromARGB(255, 244, 244, 244),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 3, vertical: 10),
                            child: Text(cell.cell[index].name,
                                style: theme.titleMedium),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Артикул:', style: theme.titleSmall),
                                Text(cell.cell[index].article,
                                    style: theme.titleSmall)
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Кількість в комірці:',
                                    style: theme.titleSmall),
                                Text(cell.cell[index].quantity.toString(),
                                    style: theme.titleSmall)
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ))
        ],
      ),
    );
  }
}
