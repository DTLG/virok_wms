import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/home_page/cubit/home_page_cubit.dart';
import 'package:virok_wms/models/noms_model.dart';
import 'package:virok_wms/ui/custom_keyboard/keyboard.dart';
import 'package:virok_wms/ui/theme/app_color.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';

import '../../../cubit/moving_out_order_data_cubit.dart';
import 'count_input.dart';

void showNomInput(BuildContext context, String cellBarcode, String docId,
    String nomBarcode, Nom nom) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => BlocProvider.value(
            value: context.read<MovingOutOrderDataCubit>(),
            child: NomInputDialog(
                docId: docId,
                nomBarcode: nomBarcode,
                cellBarcode: cellBarcode,
                nom: nom),
          ));
}

class NomInputDialog extends StatefulWidget {
  const NomInputDialog(
      {super.key,
      required this.cellBarcode,
      required this.docId,
      required this.nomBarcode,
      required this.nom});

  final String nomBarcode;
  final String cellBarcode;
  final Nom nom;
  final String docId;

  @override
  State<NomInputDialog> createState() => _NomInputDialogState();
}

class _NomInputDialogState extends State<NomInputDialog> {
  final nomController = TextEditingController();
  final cellController = TextEditingController();
  final nomFocusNode = FocusNode();
  final cellFocusNode = FocusNode();

  @override
  void initState() {
    context
        .read<MovingOutOrderDataCubit>()
        .getNom(widget.docId, widget.nomBarcode, widget.cellBarcode, widget.nom.taskNumber);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool cameraScaner = context.read<HomePageCubit>().state.cameraScaner;

    return WillPopScope(
      onWillPop: () async {
        await context.read<MovingOutOrderDataCubit>().clear();
        return true;
      },
      child: AlertDialog(
        iconPadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        icon: DialogHead(
          title: widget.nom.article,
          onPressed: () {
            context.read<MovingOutOrderDataCubit>().clear();
            Navigator.pop(context);
          },
        ),
        content: BlocBuilder<MovingOutOrderDataCubit, MovingOutOrderDataState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(
                  state.nom == Nom.empty ? widget.nom.name : state.nom.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 45,
                  child: TextField(
                    textAlignVertical: TextAlignVertical.bottom,
                    autofocus: cameraScaner ? false : true,
                    textInputAction: TextInputAction.next,
                    controller: cellController,
                    focusNode: cellFocusNode,
                    onSubmitted: (value) {
                      final bool res = context
                          .read<MovingOutOrderDataCubit>()
                          .checkCell(
                              cellController.text,
                              state.nom.cells.isEmpty
                                  ? widget.nom.cells
                                  : state.nom.cells);
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
                                      .read<MovingOutOrderDataCubit>()
                                      .checkCell(
                                          cellController.text,
                                          state.nom.cells.isEmpty
                                              ? widget.nom.cells
                                              : state.nom.cells);
                                },
                              )
                            : null),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 45,
                  child: TextField(
                    textAlignVertical: TextAlignVertical.bottom,
                    controller: nomController,
                    focusNode: nomFocusNode,
                    onSubmitted: (value) {
                      context
                          .read<MovingOutOrderDataCubit>()
                          .scan(value, state.nom);
                      nomController.clear();
                      nomFocusNode.requestFocus();
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        hintText: 'Відскануйте товар',
                        suffixIcon: cameraScaner
                            ? CameraScanerButton(
                                scan: (value) {
                                  context
                                      .read<MovingOutOrderDataCubit>()
                                      .scan(value, state.nom);

                                  setState(() {});
                                },
                              )
                            : null),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.dialogGreen),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Кількість в замовленні:',
                        style: theme.textTheme.titleSmall!
                            .copyWith(color: Colors.black),
                      ),
                      Text(
                        state.nom == Nom.empty
                            ? widget.nom.qty.toStringAsFixed(0)
                            : state.nom.qty.toStringAsFixed(0),
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<MovingOutOrderDataCubit, MovingOutOrderDataState>(
                  builder: (context, state) {
                    double dialogSize = MediaQuery.of(context).size.height;
                    final count = state.nom.count;
                    return Text(
                      state.count == 0
                          ? count.toStringAsFixed(0)
                          : state.count.toStringAsFixed(0),
                      style: TextStyle(fontSize: dialogSize < 700 ? 65 : 120),
                    );
                  },
                )
              ]),
            );
          },
        ),
        actionsPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
        actions: [
          BlocBuilder<MovingOutOrderDataCubit, MovingOutOrderDataState>(
            builder: (context, state) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Color.fromARGB(255, 251, 206, 43))),
                          onPressed: () {
                            showDialog(
                              barrierColor: const Color.fromARGB(150, 0, 0, 0),
                              context: context,
                              builder: (_) => BlocProvider.value(
                                value: context.read<MovingOutOrderDataCubit>(),
                                child: CellListdialog(
                                  cells: state.nom.cells,
                                ),
                              ),
                            );
                          },
                          child: const Text('Комірки')),
                      ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Color.fromARGB(255, 140, 193, 219))),
                          onPressed: () {
                            showDialog(
                              barrierColor: const Color.fromARGB(150, 0, 0, 0),
                              context: context,
                              builder: (_) => BlocProvider.value(
                                value: context.read<MovingOutOrderDataCubit>(),
                                child: ChangeQuantity(
                                  qty: state.nom.qty,
                                  nom: state.nom,
                                  docId: widget.docId,
                                  count: state.nom.count,
                                ),
                              ),
                            );
                          },
                          child: const SizedBox(
                            width: 120,
                            child: Text(
                              'Коригувати замовлення',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(context
                                          .read<MovingOutOrderDataCubit>()
                                          .state
                                          .count >
                                      0
                                  ? Colors.green
                                  : Colors.grey)),
                          onPressed: () {
                            final state =
                                context.read<MovingOutOrderDataCubit>().state;
                            if (state.nomBarcode.isNotEmpty) {
                              showCountAlert(context, state.nom);
                            }
                          },
                          child: const Text('Ввести в ручну')),
                      ElevatedButton(
                          onPressed: () {
                            final basket = state.nom.baskets.isEmpty
                                ? ''
                                : state.nom.baskets.first.bascket;

                            if (cellController.text.isNotEmpty &&
                                state.nomBarcode.isNotEmpty) {
                              context.read<MovingOutOrderDataCubit>().send(
                                  state.nomBarcode,
                                  state.nom.docNumber,
                                  state.cellBarcode,
                                  basket,
                                  state.nom.count);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Додати'))
                    ],
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class ChangeQuantity extends StatefulWidget {
  const ChangeQuantity(
      {super.key,
      required this.qty,
      required this.nom,
      required this.docId,
      required this.count});

  final double qty;
  final double count;
  final Nom nom;
  final String docId;

  @override
  State<ChangeQuantity> createState() => _ChangeQuantityState();
}

class _ChangeQuantityState extends State<ChangeQuantity> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        const Spacer(),
        AlertDialog(
          iconPadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          icon: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 50,
              ),
              Text(
                "Зміна кількості",
                style: theme.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close))
            ],
          ),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Кількість в замовленні:'),
              trailing: Text(widget.qty.toString()),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              autofocus: true,
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]*')),
              ],
              decoration: const InputDecoration(hintText: 'Введіть кількість'),
            ),
            const SizedBox(
              height: 5,
            ),
          ]),
          actionsPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
                onPressed: () {
                  double inputCount = double.parse(controller.text);
                  if (controller.text.isNotEmpty) {
                    if (inputCount < widget.count) {
                      Alerts(
                              msg: 'Введена менаша кількість ніж  відскановано',
                              context: context)
                          .showError();
                    } else if (inputCount == widget.qty) {
                      Alerts(
                              msg:
                                  'Введена та сама кількість що й в замовленні',
                              context: context)
                          .showError();
                    } else {
                      context.read<MovingOutOrderDataCubit>().changeQty(
                          double.parse(controller.text),
                          widget.nom,
                          widget.docId);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('Змінити'))
          ],
        ),
        Keyboard(
          controller: controller,
        )
      ],
    );
  }
}

class CellListdialog extends StatelessWidget {
  const CellListdialog({super.key, required this.cells});

  final List<Cell> cells;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
        iconPadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        icon: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 45,
            ),
            Text(
              "Комірки",
              style: theme.textTheme.titleMedium!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close))
          ],
        ),
        content: SizedBox(
            height: cells.length * 60,
            child: ListView.builder(
              itemCount: cells.length,
              itemBuilder: (context, index) => ListTile(
                onTap: () {
                  Navigator.pop(context);
                },
                title: Text(cells[index].nameCell),
              ),
            )));
  }
}
