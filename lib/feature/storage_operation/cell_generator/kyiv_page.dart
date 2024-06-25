import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';

import 'cubit/cel_generator_cubit.dart';

enum WellScrollViewType { pallet, mezonin, service, epicentr }

extension PlacementStatusX on WellScrollViewType {
  bool get isPalet => this == WellScrollViewType.pallet;
  bool get isMezonin => this == WellScrollViewType.mezonin;
  bool get isService => this == WellScrollViewType.service;
  bool get isEpicentr => this == WellScrollViewType.epicentr;
}

class KyivCellGeneratorPage extends StatelessWidget {
  const KyivCellGeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CelLGeneratorCubit(),
      child:  const CellGeneratorView()
         
    );
  }
}

class CellGeneratorView extends StatefulWidget {
  const CellGeneratorView({super.key});

  @override
  State<CellGeneratorView> createState() => _CellGeneratorViewState();
}

class _CellGeneratorViewState extends State<CellGeneratorView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final tabCount = 4;

  @override
  void initState() {
    _tabController = TabController(
        vsync: this,
        length: tabCount,
        animationDuration: const Duration(milliseconds: 50));

    _tabController.addListener(() {
      if (_tabController.index != _tabController.previousIndex) {
        context.read<CelLGeneratorCubit>().init();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Генератор комірок'),
          bottom: TabBar(
              labelStyle:
                  const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500),
              controller: _tabController,
              tabs: const [
                Tab(
                  text: 'Палетний',
                ),
                Tab(
                  text: 'Мезонін',
                ),
                Tab(
                  text: 'Епіцентр',
                ),
                Tab(
                  text: 'Сервіс',
                )
              ]),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(controller: _tabController, children: const [
                WellScrollView(
                  type: WellScrollViewType.pallet,
                ),
                WellScrollView(
                  type: WellScrollViewType.mezonin,
                ),
                WellScrollView(
                  type: WellScrollViewType.epicentr,
                ),
                WellScrollView(
                  type: WellScrollViewType.service,
                ),
              ]),
            ),
          ],
        ));
  }
}

class WellScrollView extends StatelessWidget {
  const WellScrollView({super.key, required this.type});

  final WellScrollViewType type;

  @override
  Widget build(BuildContext context) {
    final themeMode = AdaptiveTheme.of(context).mode;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (type.isEpicentr) const Epicentrtitle(),
              if (type.isPalet) const PalletTitle(),
              if (type.isMezonin || type.isService) const MezoninTitle()
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
              child: type.isMezonin
                  ? const Mezonin()
                  : type.isEpicentr
                      ? const Epicentr()
                      : type.isService
                          ? const Service()
                          : type.isPalet
                              ? const Pallet()
                              : const SizedBox()),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 50,
              ),
              GeneralButton(
                  lable: 'Друкувати',
                  onPressed: () {
                    type.isMezonin
                        ? context.read<CelLGeneratorCubit>().printMezoninLable()
                        : type.isService
                            ? context
                                .read<CelLGeneratorCubit>()
                                .printServiceLable()
                            : type.isPalet
                                ? context
                                    .read<CelLGeneratorCubit>()
                                    .printKyivPalletLable()
                                : context
                                    .read<CelLGeneratorCubit>()
                                    .printKyivEpicentreLable();
                  }),
              BlocBuilder<CelLGeneratorCubit, CellGeneratorState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 50),
                    child: IconButton(
                        onPressed: () {
                          context.read<CelLGeneratorCubit>().changeArrow();
                        },
                        icon: Icon(
                          state.arrowUp
                              ? Icons.arrow_upward
                              : Icons.arrow_downward_rounded,
                          color:
                              themeMode.isLight ? Colors.black : Colors.white,
                          size: 40,
                        )),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

class Epicentrtitle extends StatelessWidget {
  const Epicentrtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 20,
        ),
        WhellScrollTitleWidget(
          title: 'Ряд',
        ),
        WhellScrollTitleWidget(
          title: 'Стелаж',
        ),
        WhellScrollTitleWidget(
          title: 'Ярус',
        ),
      ],
    );
  }
}

class PalletTitle extends StatelessWidget {
  const PalletTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 20,
        ),
        WhellScrollTitleWidget(
          title: 'Зона',
        ),
        WhellScrollTitleWidget(
          title: 'Ряд',
        ),
        WhellScrollTitleWidget(
          title: 'Стелаж',
        ),
        WhellScrollTitleWidget(
          title: 'Ярус',
        ),
        WhellScrollTitleWidget(
          title: 'Комірка',
        ),
      ],
    );
  }
}

class MezoninTitle extends StatelessWidget {
  const MezoninTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 20,
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
          title: 'Ярус',
        ),
        WhellScrollTitleWidget(
          title: 'Комірка',
        ),
      ],
    );
  }
}

class Epicentr extends StatelessWidget {
  const Epicentr({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "E",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          width: 5,
        ),
        WellScrollWidget(
          maxValue: 40,
          onChanged: (value) =>
              context.read<CelLGeneratorCubit>().setRange(value),
        ),
        WellScrollWidget(
          maxValue: 40,
          onChanged: (value) =>
              context.read<CelLGeneratorCubit>().setRack(value),
        ),
        WellScrollWidget(
          maxValue: 40,
          onChanged: (value) =>
              context.read<CelLGeneratorCubit>().setFloorRack(value),
        ),
      ],
    );
  }
}

class Mezonin extends StatelessWidget {
  const Mezonin({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "M",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
        WellScrollWidget(
          maxValue: 40,
          onChanged: (value) =>
              context.read<CelLGeneratorCubit>().setFloor(value),
        ),
        WellScrollWidget(
          maxValue: 40,
          onChanged: (value) =>
              context.read<CelLGeneratorCubit>().setRange(value),
        ),
        WellScrollWidget(
          maxValue: 40,
          onChanged: (value) =>
              context.read<CelLGeneratorCubit>().setRack(value),
        ),
        WellScrollWidget(
          maxValue: 40,
          onChanged: (value) =>
              context.read<CelLGeneratorCubit>().setFloorRack(value),
        ),
        WellScrollWidget(
          maxValue: 40,
          onChanged: (value) =>
              context.read<CelLGeneratorCubit>().setCell(value),
        ),
      ],
    );
  }
}

class Service extends StatelessWidget {
  const Service({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "S",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
        WellScrollWidget(
          maxValue: 40,
          onChanged: (value) =>
              context.read<CelLGeneratorCubit>().setFloor(value),
        ),
        WellScrollWidget(
          maxValue: 40,
          onChanged: (value) =>
              context.read<CelLGeneratorCubit>().setRange(value),
        ),
        WellScrollWidget(
          maxValue: 40,
          onChanged: (value) =>
              context.read<CelLGeneratorCubit>().setRack(value),
        ),
        WellScrollWidget(
          maxValue: 40,
          onChanged: (value) =>
              context.read<CelLGeneratorCubit>().setFloorRack(value),
        ),
        WellScrollWidget(
          maxValue: 40,
          onChanged: (value) =>
              context.read<CelLGeneratorCubit>().setCell(value),
        ),
      ],
    );
  }
}

class Pallet extends StatelessWidget {
  const Pallet({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "P",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
        WellScrollPalletWidget(
          maxValue: 5,
          onChanged: (value) =>
              context.read<CelLGeneratorCubit>().setFloor(value),
        ),
        WellScrollWidget(
          maxValue: 40,
          onChanged: (value) =>
              context.read<CelLGeneratorCubit>().setRange(value),
        ),
        WellScrollWidget(
          maxValue: 40,
          onChanged: (value) =>
              context.read<CelLGeneratorCubit>().setRack(value),
        ),
        WellScrollWidget(
          maxValue: 40,
          onChanged: (value) =>
              context.read<CelLGeneratorCubit>().setFloorRack(value),
        ),
        WellScrollWidget(
          maxValue: 40,
          onChanged: (value) =>
              context.read<CelLGeneratorCubit>().setCell(value),
        ),
      ],
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

class WellScrollPalletWidget extends StatefulWidget {
  const WellScrollPalletWidget(
      {super.key, required this.maxValue, required this.onChanged});

  final int maxValue;
  final ValueChanged<int> onChanged;

  @override
  State<WellScrollPalletWidget> createState() => _WellScrollPalletWidgetState();
}

class _WellScrollPalletWidgetState extends State<WellScrollPalletWidget> {
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
        if (int.parse(numberText) < 10) {
          res = numberText.replaceFirst('0', '');
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

class CellGeneratorLvivView extends StatefulWidget {
  const CellGeneratorLvivView({super.key});

  @override
  State<CellGeneratorLvivView> createState() => _CellGeneratorLvivViewState();
}

class _CellGeneratorLvivViewState extends State<CellGeneratorLvivView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final tabCount = 3;

  @override
  void initState() {
    _tabController = TabController(
        vsync: this,
        length: tabCount,
        animationDuration: const Duration(milliseconds: 50));

    _tabController.addListener(() {
      if (_tabController.index != _tabController.previousIndex) {
        context.read<CelLGeneratorCubit>().init();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: tabCount,
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Генератор комірок'),
              bottom: TabBar(controller: _tabController, tabs: const [
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
            body: TabBarView(controller: _tabController, children: const [
              WellScrollLvivView(
                type: WellScrollViewType.pallet,
              ),
              WellScrollLvivView(
                type: WellScrollViewType.mezonin,
              ),
              WellScrollLvivView(
                type: WellScrollViewType.service,
              ),
            ])));
  }
}

class WellScrollLvivView extends StatelessWidget {
  const WellScrollLvivView({super.key, required this.type});

  final WellScrollViewType type;

  @override
  Widget build(BuildContext context) {
    final maxCount = type.isMezonin ? 40 : 20;
    final themeMode = AdaptiveTheme.of(context).mode;

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
                title: 'Ярус',
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
          type.isPalet
              ? GeneralButton(
                  lable: 'Друкувати',
                  onPressed: () {
                    type.isMezonin
                        ? context.read<CelLGeneratorCubit>().printMezoninLable()
                        : type.isService
                            ? context
                                .read<CelLGeneratorCubit>()
                                .printServiceLable()
                            : context
                                .read<CelLGeneratorCubit>()
                                .printLvivPalletLable();
                  })
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 50,
                    ),
                    GeneralButton(
                        lable: 'Друкувати',
                        onPressed: () {
                          type.isMezonin
                              ? context
                                  .read<CelLGeneratorCubit>()
                                  .printMezoninLable()
                              : type.isService
                                  ? context
                                      .read<CelLGeneratorCubit>()
                                      .printServiceLable()
                                  : context
                                      .read<CelLGeneratorCubit>()
                                      .printLvivPalletLable();
                        }),
                    BlocBuilder<CelLGeneratorCubit, CellGeneratorState>(
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 50),
                          child: IconButton(
                              onPressed: () {
                                context
                                    .read<CelLGeneratorCubit>()
                                    .changeArrow();
                              },
                              icon: Icon(
                                state.arrowUp
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward_rounded,
                                color: themeMode.isLight
                                    ? Colors.black
                                    : const Color.fromRGBO(255, 255, 255, 1),
                                size: 40,
                              )),
                        );
                      },
                    ),
                  ],
                )
        ],
      ),
    );
  }
}
