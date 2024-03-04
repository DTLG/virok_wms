import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';

import 'cubit/cel_generator_cubit.dart';

enum WellScrollViewType { pallet, mezonin, service }

extension PlacementStatusX on WellScrollViewType {
  bool get isPalet => this == WellScrollViewType.pallet;
  bool get isMezonin => this == WellScrollViewType.mezonin;
  bool get isService => this == WellScrollViewType.service;
}

class CellGeneratorPage extends StatelessWidget {
  const CellGeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CelLGeneratorCubit(),
      child: const CellGeneratorView(),
    );
  }
}

class CellGeneratorView extends StatefulWidget {
  const CellGeneratorView({super.key});

  @override
  State<CellGeneratorView> createState() => _CellGeneratorViewState();
}

class _CellGeneratorViewState extends State<CellGeneratorView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Генератор комірок'),
              bottom: const TabBar(tabs: [
                Tab(
                  text: 'Палетний',
                ),
                Tab(
                  text: 'Мезонін',
                ),
                Tab(
                  text: 'Сервіс',
                )
              ]),
            ),
            body: const TabBarView(children: [
              WellScrollView(
                type: WellScrollViewType.pallet,
              ),
              WellScrollView(
                type: WellScrollViewType.mezonin,
              ),
              WellScrollView(
                type: WellScrollViewType.service,
              ),
            ])));
  }
}

class WellScrollView extends StatelessWidget {
  const WellScrollView({super.key, required this.type});

  final WellScrollViewType type;

  @override
  Widget build(BuildContext context) {
    final maxCount = type.isMezonin ? 40 : 20;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: type.isMezonin || type.isService ? 30 : 0,
              ),
              type.isMezonin || type.isService
                  ? const WhellScrollTitleWidget(
                      title: 'Поверх',
                    )
                  : const SizedBox(),
              const WhellScrollTitleWidget(
                title: 'Ряд',
              ),
              const WhellScrollTitleWidget(
                title: 'Стелаж',
              ),
              const WhellScrollTitleWidget(
                title: 'Поверх Стелажа',
              ),
              const WhellScrollTitleWidget(
                title: 'Комірка',
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                type.isMezonin
                    ? const Text(
                        "M",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      )
                    : type.isService
                        ? const Text(
                            "S",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500),
                          )
                        : const SizedBox(),
                const SizedBox(
                  width: 5,
                ),
                type.isMezonin || type.isService
                    ? WellScrollWidget(
                        maxValue: maxCount,
                        onChanged: (value) =>
                            context.read<CelLGeneratorCubit>().setFloor(value),
                      )
                    : const SizedBox(),
                WellScrollWidget(
                  maxValue: maxCount,
                  onChanged: (value) =>
                      context.read<CelLGeneratorCubit>().setRange(value),
                ),
                WellScrollWidget(
                  maxValue: maxCount,
                  onChanged: (value) =>
                      context.read<CelLGeneratorCubit>().setRack(value),
                ),
                WellScrollWidget(
                  maxValue: maxCount,
                  onChanged: (value) =>
                      context.read<CelLGeneratorCubit>().setFloorRack(value),
                ),
                WellScrollWidget(
                  maxValue: maxCount,
                  onChanged: (value) =>
                      context.read<CelLGeneratorCubit>().setCell(value),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          GeneralButton(
              lable: 'Друкувати',
              onPressed: () {
                type.isMezonin
                    ? context.read<CelLGeneratorCubit>().printMezoninLable()
                    : type.isService
                        ? context.read<CelLGeneratorCubit>().printServiceLable()
                        : context.read<CelLGeneratorCubit>().printPalletLable();
              })
        ],
      ),
    );
  }
}

class WellScrollWidget extends StatefulWidget {
  const WellScrollWidget(
      {super.key, required this.maxValue, required this.onChanged});

  final int maxValue;
  final ValueChanged<int> onChanged;

  @override
  State<WellScrollWidget> createState() => _WellScrollWidgetState();
}

class _WellScrollWidgetState extends State<WellScrollWidget> {
  int index = 1;

  @override
  Widget build(BuildContext context) {
    final theme = AdaptiveTheme.of(context).mode;
    final Color borderColor = theme.isLight ? Colors.black : Colors.grey;
    final Color selectedTextColor =
        theme.isLight ? Colors.black : const Color.fromARGB(255, 255, 255, 255);

    return NumberPicker(
      minValue: 1,
      maxValue: widget.maxValue,
      value: index,
      zeroPad: true,
      infiniteLoop: true,
      itemWidth: 58,
      itemHeight: 50,
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(color: borderColor),
              bottom: BorderSide(color: borderColor))),
      onChanged: (value) {
        widget.onChanged(value);
        setState(() {
          index = value;
        });
      },
      textStyle: const TextStyle(color: Colors.grey, fontSize: 20),
      selectedTextStyle: TextStyle(
          color: selectedTextColor, fontSize: 25, fontWeight: FontWeight.w500),
      textMapper: (numberText) {
        String res = '';
        if (widget.maxValue < 10) {
          res = '0$numberText';
        } else {
          res = numberText;
        }
        return res;
      },
    );
  }
}

class WhellScrollTitleWidget extends StatelessWidget {
  const WhellScrollTitleWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      child: Text(
        title,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );
  }
}
