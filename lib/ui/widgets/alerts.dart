import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter_beep/flutter_beep.dart';
import 'package:virok_wms/feature/selection/cubit/selection_order_data_cubit.dart';
import 'package:virok_wms/ui/widgets/general_button.dart';
import 'package:virok_wms/ui/widgets/sound_interface.dart';

import '../../models/noms_model.dart';
import '../custom_keyboard/keyboard.dart';

SoundInterface soundInterface = SoundInterface();

class Alerts {
  final String msg;
  final Color color;
  final BuildContext context;
  final bool icon;
  final Function()? onConfirm; // New parameter for the 'Yes' button action

  Alerts({
    required this.msg,
    this.color = const Color.fromARGB(255, 47, 46, 46),
    required this.context,
    this.icon = false,
    this.onConfirm, // Initialize the new parameter
  });

  showToast() {
    // Fluttertoast.showToast(
    //   msg: msg,
    //   toastLength: Toast.LENGTH_SHORT,
    //   gravity: ToastGravity.BOTTOM,
    //   backgroundColor: color,
    //   textColor: Colors.white,
    //   fontSize: 16.0,
    // );
  }

  showError() {
    soundInterface.play(Event.error);
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
              child: const Text('Продовжити'),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
  }

  // New method for showing a dialog with "Yes" and "Cancel" buttons
  showDialogue() {
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
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog on "Cancel"
              },
              child: const Text('Скасувати'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                if (onConfirm != null) {
                  onConfirm!(); // Call the function if it's provided
                }
              },
              child: const Text('Так'),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
  }
}

class InputCountAlert extends StatefulWidget {
  const InputCountAlert(
      {super.key, required this.onChanged, required this.nom});

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
                  context.read<SelectionOrderDataCubit>().manualCountIncrement(
                      controller.text, widget.nom.qty, widget.nom.count);
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

// void showClosingCheck(
//   BuildContext context,
//   String massage,
//   FocusNode focusNode, {
//   VoidCallback? yesButton,
//   VoidCallback? noButton,
// }) {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         content: Text(
//           massage,
//           style: Theme.of(context).textTheme.titleLarge,
//           textAlign: TextAlign.center,
//         ),
//         actionsAlignment: MainAxisAlignment.spaceAround,
//         actions: [
//           Row(
//             children: [
//               Expanded(
//                   child: GeneralButton(onPressed: yesButton, lable: 'Так')),
//               Expanded(child: GeneralButton(onPressed: noButton, lable: 'Ні')),
//             ],
//           )
//         ],
//         contentPadding: const EdgeInsets.all(10),
//         actionsPadding: EdgeInsets.zero,
//       );
//     },
//   );
//   focusNode.requestFocus();
// }

class YesOrNoDialog extends StatelessWidget {
  const YesOrNoDialog(
      {super.key,
      this.massage,
      required this.noButton,
      required this.yesButton,
      this.yesLable = 'Так',
      this.noLable = 'Ні',
      this.buttonTextStyle});

  final String? massage;
  final VoidCallback yesButton;
  final VoidCallback noButton;
  final String yesLable;
  final String noLable;
  final TextStyle? buttonTextStyle;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: massage != null
          ? Text(
              massage!,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            )
          : null,
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        Row(
          children: [
            Expanded(
                child: GeneralButton(
              onPressed: yesButton,
              lable: yesLable,
              textStyle: buttonTextStyle,
            )),
            Expanded(
                child: GeneralButton(
              onPressed: noButton,
              lable: noLable,
              textStyle: buttonTextStyle,
            )),
          ],
        )
      ],
      contentPadding: massage != null ? const EdgeInsets.all(10) : null,
      actionsPadding: EdgeInsets.zero,
    );
  }
}
