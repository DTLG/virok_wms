import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/home_page/cubit/home_page_cubit.dart';
import 'package:virok_wms/feature/inventory/inventory_by_cells/task_noms/cubit/task_noms_cubit.dart';
import 'package:virok_wms/ui/custom_keyboard/keyboard.dart';
import 'package:virok_wms/ui/widgets/camera_scaner_button.dart';
import 'package:virok_wms/ui/widgets/dialog_head.dart';

addNomDialog(BuildContext context, String docNumber, FocusNode focusNode,
    String cellBarcode) {
  showDialog(
    context: context,
    builder: (_) => BlocProvider.value(
      value: context.read<InventoryByCellsTaskNomsCubit>(),
      child: Stack(
        children: [
          AddCellDialog(
            docNumber: docNumber,
            cellBarcode: cellBarcode,
          ),
          
        ],
      ),
    ),
  );
  focusNode.requestFocus();
}

class AddCellDialog extends StatefulWidget {
  const AddCellDialog(
      {super.key, required this.docNumber, required this.cellBarcode});

  final String docNumber;
  final String cellBarcode;

  @override
  State<AddCellDialog> createState() => _AddCellDialogState();
}

class _AddCellDialogState extends State<AddCellDialog> {
  final countController = TextEditingController();
  final nomController = TextEditingController();
  final focusNode = FocusNode();
  String initialValue = 'Кондиція';
  String nomStatus = '';
  @override
  void initState() {
    nomStatus = initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool cameraScaner = context.read<HomePageCubit>().state.cameraScaner;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AlertDialog(
          iconPadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          icon: DialogHead(title: '', onPressed: () => Navigator.pop(context)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                controller: nomController,
                textInputAction: TextInputAction.next,
                onSubmitted: (value) {
                  focusNode.requestFocus();
                },
                decoration: InputDecoration(
                    hintText: 'Відскануйте товар',
                    suffixIcon: cameraScaner
                        ? CameraScanerButton(
                            scan: (value) {
                              nomController.text = value;
                              focusNode.requestFocus();
                            },
                          )
                        : null),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  SizedBox(
                    width: 110,
                    child: TextField(
                      focusNode: focusNode,
                      autofocus: cameraScaner ? false : true,
                      textInputAction: TextInputAction.next,
                      controller: countController,
                      decoration: InputDecoration(
                          hintText: 'Кількість',
                          suffixIcon: cameraScaner
                              ? CameraScanerButton(
                                  scan: (value) {
                                    countController.text = value;
                                  },
                                )
                              : null),
                    ),
                  )
                ],
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
                  if (nomController.text.isEmpty || countController.text.isEmpty)return;
                  context.read<InventoryByCellsTaskNomsCubit>().sendNom(
                      nomController.text,
                      countController.text,
                      widget.docNumber,
                      nomStatus,
                      widget.cellBarcode);
                  Navigator.pop(context);
                },
                child: const Text('Додати'))
          ],
        ),
        Keyboard(controller: countController)
      ],
    );
  }
}
