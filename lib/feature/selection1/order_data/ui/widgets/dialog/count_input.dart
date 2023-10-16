import 'package:flutter/material.dart';
import 'package:virok_wms/models/noms_model.dart';
import 'package:virok_wms/ui/widgets/alerts.dart';

void showCountAlert(
  BuildContext context,
  Nom nom,
) {
  showDialog(
    barrierColor: Color.fromARGB(149, 0, 0, 0),
      context: context,
      builder: (_) {
        return InputCountAlert(
          onPressed: () {
            Navigator.pop(context);
          },
          onChanged: (value) {
            if (value.split('').first == '-') {
              Alerts(context: context, msg: 'Введене відємне число')
                  .showError();
              value = '';
            } else {}
          },
        );
      });
}
