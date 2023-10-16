import 'package:flutter/material.dart';
import 'package:virok_wms/models/noms_model.dart';

import 'count_input.dart';

void showNomInput(BuildContext context, Nom nom) {
  showDialog(
      context: context,
      builder: (context) => NomInputDialog(
            nom: nom,
          ));
}

class NomInputDialog extends StatefulWidget {
  const NomInputDialog({super.key, required this.nom});

  final Nom nom;

  @override
  State<NomInputDialog> createState() => _NomInputDialogState();
}

class _NomInputDialogState extends State<NomInputDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      iconPadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      icon: Align(
        alignment: Alignment.centerRight,
        child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close)),
      ),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(
          widget.nom.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13),
        ),
        const SizedBox(
          height: 8,
        ),
        const TextField(
          decoration: InputDecoration(hintText: 'Відскануйте комірку'),
        ),
        const SizedBox(
          height: 5,
        ),
        const TextField(
          decoration: InputDecoration(hintText: 'Відскануйте товар'),
        ),
        const SizedBox(
          height: 5,
        ),
      ]),
      actions: [
        ElevatedButton(
            onPressed: () {
              showCountAlert(context, widget.nom);
            },
            child: const Text('Ввести')),
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Додати'))
      ],
    );
  }
}
