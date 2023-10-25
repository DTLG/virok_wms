import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/selection/cubit/selection_order_data_cubit.dart';
import 'package:virok_wms/models/noms_model.dart';

import 'count_input.dart';

void showNomInput(BuildContext context, Nom nom, ) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => BlocProvider.value(
            value: context.read<SelectionOrderDataCubit>(),
            child: NomInputDialog(
              nom: nom,
              
            ),
          ));
}

class NomInputDialog extends StatefulWidget {
  const NomInputDialog({super.key, required this.nom});

  final Nom nom;

  @override
  State<NomInputDialog> createState() => _NomInputDialogState();
}

class _NomInputDialogState extends State<NomInputDialog> {
  final nomController = TextEditingController();
  final cellController = TextEditingController();
  final focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await context.read<SelectionOrderDataCubit>().clear();
        return true;
      },
      child: AlertDialog(
        iconPadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        icon: Align(
          alignment: Alignment.centerRight,
          child: IconButton(
              onPressed: () {
                context.read<SelectionOrderDataCubit>().clear();
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
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              autofocus: true,
              textInputAction: TextInputAction.next,
              controller: cellController,
              decoration:
                  const InputDecoration(hintText: 'Відскануйте комірку'),
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: nomController,
              focusNode: focusNode,
              onSubmitted: (value) {
                context.read<SelectionOrderDataCubit>().scan(value, widget.nom);
                nomController.clear();
                focusNode.requestFocus();
                setState(() {});
              },
              decoration: const InputDecoration(hintText: 'Відскануйте товар'),
            ),
            const SizedBox(
              height: 5,
            ),
            BlocBuilder<SelectionOrderDataCubit, SelectionOrderDataState>(
              builder: (context, state) {
                double dialogSize = MediaQuery.of(context).size.height;
                return Text(
                  state.count.toString(),
                  style: TextStyle(fontSize: dialogSize < 700 ? 65 : 120),
                );
              },
            )
          ]),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actionsPadding: const EdgeInsets.all(5),
        actions: [
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      context.read<SelectionOrderDataCubit>().state.count > 0
                          ? Colors.green
                          : Colors.grey)),
              onPressed: () {
                final state = context.read<SelectionOrderDataCubit>().state;
                if (state.nomBarcode.isNotEmpty) {
                  showCountAlert(context, widget.nom);
                }
              },
              child: const Text('Ввести в ручну')),
          ElevatedButton(
              onPressed: () {
                final state = context.read<SelectionOrderDataCubit>().state;
                if (cellController.text.isNotEmpty &&
                    state.nomBarcode.isNotEmpty) {
                  context.read<SelectionOrderDataCubit>().send(
                      state.nomBarcode,
                      state.count,
                      widget.nom.docNumber,
                      cellController.text,
                      widget.nom.basckets.first.bascket);
                  Navigator.pop(context);
                }
              },
              child: const Text('Додати'))
        ],
      ),
    );
  }
}
