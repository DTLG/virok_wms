import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:virok_wms/feature/selection/cubit/selection_order_data_cubit.dart';

import '../../models/noms_model.dart';
import '../custom_keyboard/keyboard.dart';

class Alerts {
  final String msg;
  final Color color;
  final BuildContext context;
  final bool icon;

  Alerts(
      {required this.msg,
      this.color = const Color.fromARGB(255, 47, 46, 46),
      required this.context,
      this.icon = false});
  showNotFoundAlert() {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  showError() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          icon: icon == false
              ? null
              : SizedBox(
                  height: 60,
                  child: Image.asset('assets/icons/basket_256.png')),
          content: Text(
            msg,
            textAlign: TextAlign.center,
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Продовжити'))
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
    FlutterBeep.beep(false);
  }
}

class InputCountAlert extends StatefulWidget {
  const InputCountAlert({super.key, required this.onChanged, required this.nom});

  final ValueChanged<String>? onChanged;
  final Nom nom;

  @override
  State<InputCountAlert> createState() => _InputCountAlertState();
}

class _InputCountAlertState extends State<InputCountAlert> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Spacer(),
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
                  onChanged: widget.onChanged,
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
                      .read<SelectionOrderDataCubit>()
                      .manualCountIncrement(controller.text,widget.nom.qty);
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
