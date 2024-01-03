import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/models/noms_model.dart';
import 'package:virok_wms/ui/custom_keyboard/keyboard.dart';
import 'package:virok_wms/ui/widgets/alerts.dart';

import '../../../cubit/returning_out_order_data_cubit.dart';
import 'count_input.dart';

void showNomInput(BuildContext context, Nom nom, String docId) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => BlocProvider.value(
            value: context.read<ReturningOutOrderDataCubit>(),
            child: NomInputDialog(
              nom: nom,
              docId: docId,
            ),
          ));
}

class NomInputDialog extends StatefulWidget {
  const NomInputDialog({super.key, required this.nom, required this.docId});

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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        await context.read<ReturningOutOrderDataCubit>().clear();
        return true;
      },
      child: AlertDialog(
        iconPadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        icon: Align(
          alignment: Alignment.centerRight,
          child: IconButton(
              onPressed: () {
                context.read<ReturningOutOrderDataCubit>().clear();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close)),
        ),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
              widget.nom.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              autofocus: true,
              textInputAction: TextInputAction.next,
              controller: cellController,
              focusNode: cellFocusNode,
              onSubmitted: (value) {
                final bool res = context
                    .read<ReturningOutOrderDataCubit>()
                    .checkCell(cellController.text, widget.nom.cells);
                if (res == false) {
                  cellController.clear();
                  cellFocusNode.requestFocus();
                }
              },
              decoration:
                  const InputDecoration(hintText: 'Відскануйте комірку'),
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: nomController,
              focusNode: nomFocusNode,
              onSubmitted: (value) {
                context.read<ReturningOutOrderDataCubit>().scan(value, widget.nom);
                nomController.clear();
                nomFocusNode.requestFocus();
                setState(() {});
              },
              decoration: const InputDecoration(hintText: 'Відскануйте товар'),
            ),
            const SizedBox(
              height: 5,
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Кількість в замовленні:',
                  style: theme.textTheme.titleSmall,
                ),
                Text(
                  widget.nom.qty.toStringAsFixed(0),
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
            BlocBuilder<ReturningOutOrderDataCubit, ReturningOutOrderDataState>(
              builder: (context, state) {
                double dialogSize = MediaQuery.of(context).size.height;
                final count = widget.nom.count;
                return Text(
                  state.count == 0
                      ? count.toStringAsFixed(0)
                      : state.count.toStringAsFixed(0),
                  style: TextStyle(fontSize: dialogSize < 700 ? 65 : 120),
                );
              },
            )
          ]),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
        actions: [
          Column(
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
                            value: context.read<ReturningOutOrderDataCubit>(),
                            child: CellListdialog(
                              cells: widget.nom.cells,
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
                            value: context.read<ReturningOutOrderDataCubit>(),
                            child: ChangeQuantity(
                              qty: widget.nom.qty,
                              nom: widget.nom,
                              docId: widget.docId,
                              count: widget.nom.count,
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
                                      .read<ReturningOutOrderDataCubit>()
                                      .state
                                      .count >
                                  0
                              ? Colors.green
                              : Colors.grey)),
                      onPressed: () {
                        final state =
                            context.read<ReturningOutOrderDataCubit>().state;
                        if (state.nomBarcode.isNotEmpty) {
                          showCountAlert(context, widget.nom);
                        }
                      },
                      child: const Text('Ввести в ручну')),
                  ElevatedButton(
                      onPressed: () {
                        final basket = widget.nom.baskets.isEmpty
                            ? ''
                            : widget.nom.baskets.first.bascket;
                        final state =
                            context.read<ReturningOutOrderDataCubit>().state;
                        if (cellController.text.isNotEmpty &&
                            state.nomBarcode.isNotEmpty) {
                          context.read<ReturningOutOrderDataCubit>().send(
                              state.nomBarcode,
                              widget.nom.docNumber,
                              state.cellBarcode,
                              basket,
                              widget.nom.count);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Додати'))
                ],
              )
            ],
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
                    if (inputCount > widget.qty) {
                      Alerts(
                              msg: 'Введена більша кількість ніж в замовленні',
                              context: context)
                          .showError();
                    } else if (inputCount < widget.count) {
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
                    } else if (inputCount == 0) {
                      Alerts(msg: 'Введене значення 0', context: context)
                          .showError();
                    } else {
                      context
                          .read<ReturningOutOrderDataCubit>()
                          .changeQty(controller.text, widget.nom, widget.docId);
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
