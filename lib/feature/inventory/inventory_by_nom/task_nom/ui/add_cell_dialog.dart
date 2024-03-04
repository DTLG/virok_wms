import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/home_page/cubit/home_page_cubit.dart';
import 'package:virok_wms/feature/inventory/inventory_by_nom/task_nom/cubit/task_nom_cubit.dart';

import 'package:virok_wms/ui/widgets/camera_scaner_button.dart';
import 'package:virok_wms/ui/widgets/dialog_head.dart';

addCellDialog(BuildContext context, String docNumber, FocusNode focusNode) {
  showDialog(
    context: context,
    builder: (_) => BlocProvider.value(
      value: context.read<InventoryByNomCellsTaskCubit>(),
      child: AddCellDialog(
        docNumber: docNumber,
      ),
    ),
  );
  focusNode.requestFocus();
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
              context.read<InventoryByNomCellsTaskCubit>().addNewCell(
                  nomController.text,
                  widget.docNumber,
                  nomStatus,
                  cellController.text);
              Navigator.pop(context);
            },
            child: const Text('Додати'))
      ],
    );
  }
}
