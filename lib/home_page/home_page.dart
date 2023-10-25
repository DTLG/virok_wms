import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:virok_wms/const.dart';
import 'package:virok_wms/home_page/cubit/home_page_cubit.dart';

import '../ui/custom_keyboard/keyboard.dart';
import '../ui/widgets/general_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomePageCubit(),
      child: BlocBuilder<HomePageCubit, HomePageState>(
        builder: (context, state) {
          return const HomeView();
        },
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool genBarButton =
        context.select((HomePageCubit cubit) => cubit.state.genBarButton);
    final bool barcodeLablePrintButton = context
        .select((HomePageCubit cubit) => cubit.state.barcodeLablePrintButton);
    final bool cellInfoButton =
        context.select((HomePageCubit cubit) => cubit.state.cellInfoButton);
    final bool basketInfoButton =
        context.select((HomePageCubit cubit) => cubit.state.basketInfoButton);

    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: const SizedBox(),
        centerTitle: true,
        title: const Text('Virok WMS'),
        actions: [
          BlocConsumer<HomePageCubit, HomePageState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state.status.isInitial) {
                context.read<HomePageCubit>().getUser();
                context.read<HomePageCubit>().getActivButton();
                context.read<HomePageCubit>().checkTsdType();
              }
              if (state.status.isSuccess) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(state.username,
                        style: theme.textTheme.titleMedium!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w500)),
                  ),
                );
              }
              return const Center();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // GeneralButton(lable: 'Прийом товару', onPressed: () {}),
            GeneralButton(
                lable: 'Розміщення товарів',
                onPressed: () {
                  Navigator.pushNamed(context, '/placementGoodsPage');
                }),
            GeneralButton(
                lable: 'Списання',
                onPressed: () {
                  Navigator.pushNamed(context, '/writing_off');
                }),

            cellInfoButton
                ? GeneralButton(
                    lable: 'Комірка',
                    onPressed: () {
                      Navigator.pushNamed(context, '/check_cell');
                    })
                : const SizedBox(),
            genBarButton
                ? GeneralButton(
                    lable: 'Присвоєння штрихкоду',
                    onPressed: () {
                      Navigator.pushNamed(context, '/barcode_generation');
                    })
                : const SizedBox(),
            barcodeLablePrintButton
                ? GeneralButton(
                    lable: 'Друк етикетки',
                    onPressed: () {
                      Navigator.pushNamed(context, '/barcode_Lable_print');
                    })
                : const SizedBox(),
            GeneralButton(
                lable: 'Завдання на відбір',
                onPressed: () {
                  bool itsMezonine =
                      context.read<HomePageCubit>().state.itsMezonine;
                  itsMezonine == false
                      ? Navigator.pushNamed(context, '/selection_P',
                          arguments: {"": ""})
                      : Navigator.pushNamed(context, '/selection_M');
                }),
            basketInfoButton
                ? GeneralButton(
                    lable: 'Кошик',
                    onPressed: () {
                      Navigator.pushNamed(context, '/check_basket');
                    })
                : const SizedBox(),

            GeneralButton(
                lable: 'Налаштування',
                onPressed: () {
                  showPinDialog(context);
                }),
          ],
        ),
      ),
    );
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
                  Navigator.pushNamed(context, '/settings');
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
