import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/feature/label_print/lable_print_page.dart';
import 'package:virok_wms/route/app_routes.dart';
import 'package:virok_wms/const.dart';
import 'package:virok_wms/ui/ui.dart';
import '../../main.dart';
import 'cubit/home_page_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leadingWidth: 120,
            leading: Align(
                alignment: const Alignment(-0.5, 0),
                child: SizedBox(
                  width: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        appVersion,
                        style: theme.textTheme.titleMedium!.copyWith(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      IconButton(
                        icon: Icon(Icons.print),
                        onPressed: () {
                          showInputDialog(context);
                        },
                      ),
                    ],
                  ),
                )),
            titleSpacing: 0,
            centerTitle: false,
            title: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Virok WMS'),
                Text(
                  'Designed by Bodya',
                  style: TextStyle(
                    fontSize: 6,
                  ),
                )
              ],
            ),
            actions: [
              BlocConsumer<HomePageCubit, HomePageState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state.status.isInitial) {
                    context.read<HomePageCubit>().getUser();
                    context.read<HomePageCubit>().checkTsdType();
                    context.read<HomePageCubit>().getActivButton();
                    context.read<HomePageCubit>().getRefreshTime();
                  }

                  return InkWell(
                    onTap: () {
                      checkLogoutDialog(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 114,
                        height: 40,
                        child: Center(
                          child: Text(state.zone,
                              textAlign: TextAlign.end,
                              style: theme.textTheme.titleMedium!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Padding(
              padding: const EdgeInsets.all(3.0),
              child: BlocBuilder<HomePageCubit, HomePageState>(
                builder: (context, state) {
                  return GridButton(
                      children: buildButtons(
                          state.selectionButton,
                          state.admissionButton,
                          state.movingButton,
                          state.returningButton,
                          state.rechargeButton,
                          state.npTtnPrintButton,
                          state.meestTtnPrintButton,
                          state.labelPrintButton,
                          state.movingDefectiveButton,
                          context));
                },
              )),
        ));
  }
}

void showPinDialog(BuildContext context) {
  showDialog(context: context, builder: (context) => const PinDialog());
}

class PinDialog extends StatefulWidget {
  const PinDialog({super.key});

  @override
  State<PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<PinDialog> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Spacer(),
        AlertDialog(
          content: SizedBox(
            height: 100,
            child: Pinput(
              autofocus: true,
              controller: controller,
              focusNode: focusNode,
              listenForMultipleSmsOnAndroid: false,
              closeKeyboardWhenCompleted: false,
              forceErrorState: true,
              obscureText: true,
              obscuringCharacter: "●",
              defaultPinTheme: defaultPinTheme,
              separatorBuilder: (index) => const SizedBox(width: 8),
              validator: (value) {
                if (value != settingsPin) {
                  Future.delayed(const Duration(milliseconds: 700), () {
                    controller.clear();
                  });
                }
                return value == settingsPin ? null : 'Невірний код';
              },
              onClipboardFound: (value) {
                debugPrint('onClipboardFound: $value');
                controller.setText(value);
              },
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              onCompleted: (pin) {
                if (pin == settingsPin) {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.settings);
                }
              },
              onChanged: (value) {},
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    width: 22,
                    height: 1,
                    color: focusedBorderColor,
                  ),
                ],
              ),
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyBorderWith(
                border: Border.all(color: Colors.redAccent),
              ),
            ),
          ),
        ),
        // Keyboard(
        //   controller: controller,
        // )
      ],
    );
  }
}

checkLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const CheckLogoutDialog(),
  );
}

void showInputDialog(BuildContext context) {
  TextEditingController textController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Скануйте qr-код принтера'),
      content: TextField(
        controller: textController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Зіскануйте код',
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Закрити'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Зберегти'),
          onPressed: () async {
            String inputText = textController.text;

            // Зберігаємо введений текст у SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('printer_host', inputText);

            Navigator.of(context).pop(); // Закрити діалогове вікно
          },
        ),
      ],
    ),
  );
}

class CheckLogoutDialog extends StatelessWidget {
  const CheckLogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Text(
        'Змінити користувача',
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        textAlign: TextAlign.center,
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: GeneralButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  lable: 'Ні'),
            ),
            Expanded(
              child: GeneralButton(
                onPressed: () async {
                  Navigator.pushNamedAndRemoveUntil(
                      context, AppRoutes.login, (route) => false);
                  final prefs = await SharedPreferences.getInstance();
                  prefs.remove('password');
                  prefs.remove('zone');
                },
                lable: 'Так',
              ),
            ),
          ],
        )
      ],
      actionsAlignment: MainAxisAlignment.spaceAround,
    );
  }
}

List<Widget> buildButtons(selection, admission, moving, returning, recharge,
    npTtnPrint, meestTtnPrint, labelPrint, movingDefective, context) {
  List<Map<String, String>> a = [];

  a.add({'name': 'CКЛАДСЬКІ ОПЕРАЦІЇ', 'path': 'storage_operation'});
  if (selection) a.add({'name': 'ЗАВДАННЯ НА ВІДБІР', 'path': 'selection'});
  if (admission) a.add({'name': 'ПОСТУПЛЕННЯ', 'path': 'admission'});
  if (moving) a.add({'name': 'ПЕРЕМІЩЕННЯ', 'path': 'moving'});
  if (returning) a.add({'name': 'ПОВЕРНЕННЯ', 'path': 'returning'});
  if (npTtnPrint) a.add({'name': 'ДРУК НАКЛАДНОЇ НП', 'path': 'npttnprint'});
  if (meestTtnPrint)
    // ignore: curly_braces_in_flow_control_structures
    a.add({'name': 'ДРУК НАКЛАДНОЇ MEEST', 'path': 'meestttnprint'});
  if (recharge) a.add({'name': 'ПІДЖИВЛЕННЯ', 'path': 'rechargin'});
  if (labelPrint) a.add({'name': 'Друк етикеток', 'path': 'label_print_page'});
  if (movingDefective)
    a.add({'name': 'Переміщення браку', 'path': 'moving_defective_page'});
  a.add({'name': 'ІНВЕНТАРИЗАЦІЯ', 'path': 'inventory'});

  List<Widget> buttons = [];

  for (var i = 0; i < a.length; i++) {
    buttons.add(
      SquareButton(
        lable: a[i]['name'].toString(),
        color: i.buttonColor == 'r'
            ? const Color.fromRGBO(148, 39, 32, 1)
            : const Color.fromRGBO(217, 219, 218, 1),
        imagePath: 'assets/image/${a[i]['path']}_${i.buttonColor}.png',
        onTap: () {
          Navigator.pushNamed(context, a[i]['path'].toString().toAppRoutes);
        },
      ),
    );
  }
  buttons.add(SquareButton(
    lable: 'НАЛАШТУВАННЯ',
    color: const Color.fromARGB(255, 96, 96, 96),
    imagePath: 'assets/image/settings.png',
    onTap: () {
      showPinDialog(context);
    },
  ));

  return buttons;
}

extension on String {
  get toAppRoutes {
    switch (this) {
      case 'storage_operation':
        return AppRoutes.storageOperations;
      case 'selection':
        return AppRoutes.selectionOrderHeadPage;
      case 'admission':
        return AppRoutes.admissionPage;
      case 'moving':
        return AppRoutes.movingPage;
      case 'returning':
        return AppRoutes.returningPage;
      case 'rechargin':
        return AppRoutes.rechargingMenuPage;
      case 'settings':
        return AppRoutes.settings;
      case 'inventory':
        return AppRoutes.inventoryPage;
      case 'npttnprint':
        return AppRoutes.npTtnPage;
      case 'meestttnprint':
        return AppRoutes.meestTtnPage;
      case 'label_print_page':
        return AppRoutes.labelPrint;
      case 'moving_defective_page':
        return AppRoutes.movingdefectivePage;
    }
  }
}
