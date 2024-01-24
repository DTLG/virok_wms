import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';

import 'cubit/cel_generator_cubit.dart';

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

class CellGeneratorView extends StatelessWidget {
  const CellGeneratorView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text('Генератор комірок'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                children: [
                  SizedBox(
                    width: 40,
                  ),
                  WhellScrollTitleWidget(
                    title: 'Поверх',
                  ),
                  WhellScrollTitleWidget(
                    title: 'Ряд',
                  ),
                  WhellScrollTitleWidget(
                    title: 'Стелаж',
                  ),
                  WhellScrollTitleWidget(
                    title: 'Поверх Стелажа',
                  ),
                  WhellScrollTitleWidget(
                    title: 'Комірка',
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    const Text(
                      "M",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),

                    const SizedBox(
                      width: 5,
                    ),
                    WellScrollWidget(
                      maxValue: 5,
                      onChanged: (value) =>
                          context.read<CelLGeneratorCubit>().setFloor(value),
                    ),
                    WellScrollWidget(
                      maxValue: 26,
                      onChanged: (value) =>
                          context.read<CelLGeneratorCubit>().setRange(value),
                    ),
                    WellScrollWidget(
                      maxValue: 6,
                      onChanged: (value) =>
                          context.read<CelLGeneratorCubit>().setRack(value),
                    ),
                    WellScrollWidget(
                      maxValue: 4,
                      onChanged: (value) => context
                          .read<CelLGeneratorCubit>()
                          .setFloorRack(value),
                    ),
                    WellScrollWidget(
                      maxValue: 10,
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
                  context.read<CelLGeneratorCubit>().printLable();
                  })
            ],
          ),
        ));
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
    final Color borderColor = theme.isLight?Colors.black:Colors.grey;
    final Color selectedTextColor =  theme.isLight?Colors.black:const Color.fromARGB(255, 255, 255, 255);

    return NumberPicker(
      minValue: 1,
      maxValue: widget.maxValue,
      value: index,
      zeroPad: true,
      infiniteLoop: true,
      itemWidth: 58,
      itemHeight: 50,
      decoration:  BoxDecoration(
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
      selectedTextStyle:  TextStyle(
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
