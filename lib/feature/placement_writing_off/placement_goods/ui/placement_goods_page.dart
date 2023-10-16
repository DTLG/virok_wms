import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/placement_writing_off/placement_writeing_off_repository/model/cell_model.dart';
import 'package:virok_wms/ui/theme/theme.dart';
import 'package:virok_wms/ui/widgets/alerts.dart';
import 'package:virok_wms/ui/widgets/went_wrong.dart';

import '../../../../ui/widgets/general_button.dart';
import '../../ui/widgets.dart';
import '../cubit/placement_goods_cubit.dart';
import 'widgets/barcode_inputs.dart';

class PlacementGoodsPage extends StatelessWidget {
  const PlacementGoodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlacementGoodsCubit(),
      child: const PlacementGoodsView(),
    );
  }
}

class PlacementGoodsView extends StatefulWidget {
  const PlacementGoodsView({super.key});

  @override
  State<PlacementGoodsView> createState() => _PlacementGoodsViewState();
}

class _PlacementGoodsViewState extends State<PlacementGoodsView> {
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            final count = context.read<PlacementGoodsCubit>().state.count;
            if (count > 0) {
              showClosingCheck(
                context,
                AppColors.darkRed,
                "Ви дійсно хочете завершити дії",
                () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/homePage', (route) => false);
                },
                () {
                  Navigator.pop(context);
                },
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'Розміщення товарів',
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(7),
            child: ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 91, 79, 179)),
                  maximumSize: MaterialStatePropertyAll(Size.fromWidth(90)),
                  padding: MaterialStatePropertyAll(EdgeInsets.all(10))),
              child: Text('Очистити',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Colors.white)),
              onPressed: () {
                context.read<PlacementGoodsCubit>().clear();
              },
            ),
          )
        ],
      ),
      body: BlocBuilder<PlacementGoodsCubit, PlacementGoodsState>(
        builder: (context, state) {
          if (state.status.isFailure) {
            return SizedBox(
              height: 400,
              child: WentWrong(
                errorDescription: state.error,
                onPressed: () {
                  Navigator.popAndPushNamed(context, '/placementGoodsPage');
                },
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const CellInput(),
                InkWell(
                  onTap: () {
                    if (state.status.isSuccess && state.cell.zone == 2) {
                      _showCellInfoDialog(context, state.cell, false,
                          context.read<PlacementGoodsCubit>());
                    }
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          const CeelInfo(),
                          BlocConsumer<PlacementGoodsCubit,
                              PlacementGoodsState>(
                            listener: (context, state) {
                              if (state.cellStatus == 0) {
                                Alerts(
                                        msg: 'Комірку не знайдено',
                                        context: context)
                                    .showError();
                              }
                              if (state.cellStatus == 3) {
                                Alerts(
                                        msg: 'Товар не належить цій комірці',
                                        context: context)
                                    .showError();
                              }
                              if (state.cellStatus == 4) {
                                Alerts(
                                        msg: 'Товар не знайдено',
                                        context: context)
                                    .showError();
                              }
                              if (state.cellStatus == 6) {
                                Alerts(
                                        msg: "Відсканований не той товар",
                                        context: context)
                                    .showError();
                              }
                              if (state.cellStatus == 5) {
                                Alerts(
                                        msg: "Розміщено",
                                        context: context,
                                        color: Colors.green)
                                    .showNotFoundAlert();
                              }
                            },
                            buildWhen: (previous, current) {
                              return current.status.isNotFound ? false : true;
                            },
                            builder: (context, state) {
                              if (state.status.isFailure) {
                                return Center(
                                  child: WentWrong(
                                    errorDescription: state.error,
                                    onPressed: () {
                                      Navigator.popAndPushNamed(
                                          context, '/placementGoodsPage');
                                    },
                                  ),
                                );
                              }
                              if (state.status.isSuccess &&
                                  state.zoneStatus == 1) {
                                return const Column(
                                  children: [
                                    QuantityInfo(),
                                    NomInfo(),
                                    NomNameInfo(),
                                  ],
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          )
                        ],
                      )),
                ),
                const CountInfo(),
              ],
            ),
          );
        },
      ),
      bottomSheet: BlocBuilder<PlacementGoodsCubit, PlacementGoodsState>(
        builder: (context, state) {
          if (state.count > 0) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GeneralButton(
                    lable: 'Розмістити',
                    onPressed: () {
                      showClosingCheck(
                        context,
                        AppColors.darkRed,
                        "Ви дійсно хочете розмістити товар",
                        () {
                          context.read<PlacementGoodsCubit>().sendNom(
                              state.cellBarcode,
                              state.nomBarcode,
                              state.count.toString());
                          focusNode.requestFocus();
                          Navigator.pop(context);
                        },
                        () {
                          Navigator.pop(context);
                        },
                      );
                    })
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class CountInput extends StatelessWidget {
  const CountInput({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SizedBox(
        width: 90,
        height: 50,
        child: TextField(
          controller: controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.datetime,
          textAlignVertical: TextAlignVertical.bottom,
          textInputAction: TextInputAction.done,
        ),
      ),
    );
  }
}

class CeelInfo extends StatelessWidget {
  const CeelInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        rowName('Комірка №:'),
        BlocBuilder<PlacementGoodsCubit, PlacementGoodsState>(
          builder: (context, state) {
            return rowValue(state.cell.cell.first.nameCell);
          },
        ),
      ],
    );
  }
}

class NomInfo extends StatelessWidget {
  const NomInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        rowName('Артикул:'),
        BlocBuilder<PlacementGoodsCubit, PlacementGoodsState>(
          buildWhen: (previous, current) {
            return current.status.isNotFound ? false : true;
          },
          builder: (context, state) {
            return rowValue(state.article.isEmpty
                ? state.cell.cell.first.article
                : state.article);
          },
        ),
      ],
    );
  }
}

class QuantityInfo extends StatelessWidget {
  const QuantityInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        rowName('Кількість в комірці:'),
        BlocBuilder<PlacementGoodsCubit, PlacementGoodsState>(
          buildWhen: (previous, current) {
            return previous != current;
          },
          builder: (context, state) {
            return rowValue(state.cell.cell.first.quantity.toString());
          },
        )
      ],
    );
  }
}

class NomNameInfo extends StatelessWidget {
  const NomNameInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        rowName('Назва товару:'),
        BlocBuilder<PlacementGoodsCubit, PlacementGoodsState>(
          buildWhen: (previous, current) {
            return current.status.isNotFound ? false : true;
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: SizedBox(
                  width: 200,
                  child: Text(
                    state.name.isEmpty
                        ? state.cell.cell.first.name
                        : state.name,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  )),
            );
          },
        )
      ],
    );
  }
}

class CountInfo extends StatelessWidget {
  const CountInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlacementGoodsCubit, PlacementGoodsState>(
      buildWhen: (previous, current) {
        return previous != current;
      },
      builder: (context, state) {
        return Text(
          state.count.toStringAsFixed(0),
          style: const TextStyle(fontSize: 150, fontWeight: FontWeight.w500),
        );
      },
    );
  }
}

_showCellInfoDialog(BuildContext context, Cell cell, bool tap, cubit) {
  showDialog(
      context: context,
      builder: (_) => CellInfoAlert(
            cell: cell,
            tap: tap,
            cubit: cubit,
          ));
}
