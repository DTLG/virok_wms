import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:virok_wms/route/app_routes.dart';
import 'package:virok_wms/const.dart';

import '../../ui/custom_keyboard/keyboard.dart';
import '../../ui/widgets/widgets.dart';

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
            leading: const SizedBox(),
            centerTitle: true,
            title: const Text('Virok WMS 1.5.1'),
            actions: [
              BlocConsumer<HomePageCubit, HomePageState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state.status.isInitial) {
                    context.read<HomePageCubit>().getUser();
                    context.read<HomePageCubit>().checkTsdType();
                  }
                  if (state.status.isSuccess) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(state.username,
                            style: theme.textTheme.titleMedium!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500)),
                      ),
                    );
                  }
                  return const Center();
                },
              ),
            ],
          ),
          body: Center(
            child: SingleChildScrollView(
                child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GeneralButton(
                      lable: 'Складські операції',
                      onPressed: () {
                        Navigator.pushNamed(
                            context, AppRoutes.storageOperations);
                      }),
                  GeneralButton(
                      lable: 'Завдання на відбір',
                      onPressed: () {
                        Navigator.pushNamed(
                            context, AppRoutes.selectionOrderHeadPage);
                      }),
                  GeneralButton(
                      lable: 'Поступлення',
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.admissionPage);
                      }),
                  GeneralButton(
                      lable: 'Переміщення',
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.movingPage);
                      }),
                  GeneralButton(
                      lable: 'Підпитка',
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.rechargePage);
                      }),
                  GeneralButton(
                      lable: 'Налаштування',
                      onPressed: () {
                        showPinDialog(context);
                      }),
                ],
              ),
            )),
          ),
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
        color: Color.fromRGBO(30, 60, 87, 1),
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
        Keyboard(
          controller: controller,
        )
      ],
    );
  }
}
