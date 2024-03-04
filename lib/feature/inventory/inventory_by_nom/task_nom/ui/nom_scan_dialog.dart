import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/home_page/cubit/home_page_cubit.dart';
import 'package:virok_wms/feature/inventory/inventory_by_nom/models/cells_by_nom.dart';
import 'package:virok_wms/feature/inventory/inventory_by_nom/task_nom/cubit/task_nom_cubit.dart';

import '../../../../../ui/ui.dart';

showInventoryByNomCellScanDialog(
    BuildContext context, CellsByNom nom, int index, FocusNode focusNode) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => BlocProvider.value(
      value: context.read<InventoryByNomCellsTaskCubit>(),
      child: _CountInputDialog(
        nom: nom,
        cell: nom.cells[index],
      ),
    ),
  );
  focusNode.requestFocus();
}

class _CountInputDialog extends StatefulWidget {
  const _CountInputDialog({required this.nom, required this.cell});

  final CellsByNom nom;
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
        context.read<InventoryByNomCellsTaskCubit>().clear();
      },
      child: AlertDialog(
        iconPadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        actionsPadding: const EdgeInsets.only(bottom: 5),
        icon: DialogHead(
          title: widget.nom.article,
          onPressed: () {
            Navigator.pop(context);

            context.read<InventoryByNomCellsTaskCubit>().clear();
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
                    .read<InventoryByNomCellsTaskCubit>()
                    .scanCell(value, widget.cell.code);

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
                                .read<InventoryByNomCellsTaskCubit>()
                                .scanCell(value, widget.cell.code);
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
                context
                    .read<InventoryByNomCellsTaskCubit>()
                    .scanNom(value, widget.nom.barcodes);
                nomController.clear();
                nomFocusNode.requestFocus();
              },
              decoration: InputDecoration(
                  hintText: 'Відскануйте товар',
                  suffixIcon: cameraScaner
                      ? CameraScanerButton(
                          scan: (value) {
                            context
                                .read<InventoryByNomCellsTaskCubit>()
                                .scanNom(value, widget.nom.barcodes);
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
            BlocBuilder<InventoryByNomCellsTaskCubit,
                InventoryByNomCellsTaskState>(
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
          BlocBuilder<InventoryByNomCellsTaskCubit,
              InventoryByNomCellsTaskState>(
            builder: (context, state) {
              return ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          state.nomBarcode.isEmpty &&
                                  cellController.text.isEmpty
                              ? Colors.grey
                              : Colors.green)),
                  onPressed: () {
                    final state =
                        context.read<InventoryByNomCellsTaskCubit>().state;
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
                final state = context.read<InventoryByNomCellsTaskCubit>().state;

                if (state.nomBarcode.isNotEmpty &&
                    cellController.text.isNotEmpty) {
                  context.read<InventoryByNomCellsTaskCubit>().sendNom(
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
      value: context.read<InventoryByNomCellsTaskCubit>(),
      child: const _MonualCountDialog(),
    ),
  );
}

class _MonualCountDialog extends StatefulWidget {
  const _MonualCountDialog();

  @override
  State<_MonualCountDialog> createState() => _MonualCountDialogState();
}

class _MonualCountDialogState extends State<_MonualCountDialog> {
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
                      .read<InventoryByNomCellsTaskCubit>()
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
