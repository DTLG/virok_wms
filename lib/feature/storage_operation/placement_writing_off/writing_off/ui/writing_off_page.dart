import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/route/app_routes.dart';
import 'package:virok_wms/ui/theme/theme.dart';
import '../../../../../ui/widgets/widgets.dart';
import '../../placement_writeing_off_repository/model/cell_model.dart';
import '../../ui/widgets.dart';
import '../cubit/writing_off_cubit.dart';
import 'widgets/barcode_inputs.dart';

class WritingOffPage extends StatelessWidget {
  const WritingOffPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WritingOffCubit(),
      child: const WritingOffView(),
    );
  }
}

class WritingOffView extends StatefulWidget {
  const WritingOffView({super.key});

  @override
  State<WritingOffView> createState() => _WritingOffViewState();
}

class _WritingOffViewState extends State<WritingOffView> {
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: AppColors.darkBlue,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () {
              final count = context.read<WritingOffCubit>().state.count;
              if (count > 0) {
                showDialog(
                  context: context,
                  builder: (context) => YesOrNoDialog(
                    massage: "Ви дійсно хочете завершити дії",
                    noButton: () {
                      Navigator.pop(context);
                    },
                    yesButton: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, AppRoutes.homePage, (route) => false);
                    },
                  ),
                );

                // showClosingCheck(
                //   context,
                //   'Ви дійсно хочете завершити дії',
                //   focusNode,
                //   yesButton: () {
                //     Navigator.pushNamedAndRemoveUntil(
                //         context, AppRoutes.homePage, (route) => false);
                //   },
                //   noButton: () {
                //     Navigator.pop(context);
                //   },
                // );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          title: const Text(
            'Списання товарів',
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(7),
              child: ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(AppColors.darkRed),
                    maximumSize: MaterialStatePropertyAll(Size.fromWidth(90)),
                    padding: MaterialStatePropertyAll(EdgeInsets.all(10))),
                child: Text('Очистити',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: Colors.white)),
                onPressed: () {
                  context.read<WritingOffCubit>().clear();
                },
              ),
            )
          ],
        ),
        body: BlocConsumer<WritingOffCubit, WritingOffState>(
          listener: (context, state) {
            if (state.cellStatus == 0) {
              Alerts(msg: 'Комірку не знайдено', context: context).showError();
            }
            if (state.cellStatus == 3) {
              Alerts(msg: 'Товар не належить цій комірці', context: context)
                  .showError();
            }
            if (state.cellStatus == 5) {
              Alerts(msg: 'Відсутність залишку на складі', context: context)
                  .showError();
            }
            if (state.cellStatus == 6) {
              Alerts(msg: 'Відсканований не той товар', context: context)
                  .showError();
            }
          },
          builder: (context, state) {
            if (state.status.isFailure) {
              return SizedBox(
                height: 400,
                child: WentWrong(
                  errorDescription: state.error,
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/writing_off');
                  },
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const BarcodeInputs(),
                  InkWell(
                    onTap: () {
                      if (state.status.isSuccess && state.cell.zone == 2) {
                        _showCellInfoDialog(context, state.cell, true,
                            context.read<WritingOffCubit>());
                      }
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            const CeelInfo(),
                            BlocBuilder<WritingOffCubit, WritingOffState>(
                              builder: (context, state) {
                                if (state.status.isFailure) {
                                  return SizedBox(
                                    height: 200,
                                    child: WentWrong(
                                      errorDescription: state.error,
                                      onPressed: () {
                                        Navigator.popAndPushNamed(
                                            context, '/writing_off');
                                      },
                                    ),
                                  );
                                }
                                if (state.status.isSuccess &&
                                        state.cell.zone == 1 ||
                                    state.name.isNotEmpty) {
                                  return const Column(
                                    children: [
                                      NomNameInfo(),
                                      ArticleInfo(),
                                      QuantityInfo(),
                                    ],
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),
                          ],
                        )),
                  ),
                  const CountInfo(),
                ],
              ),
            );
          },
        ),
        bottomSheet: BlocBuilder<WritingOffCubit, WritingOffState>(
          builder: (context, state) {
            if (state.count > 0) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GeneralButton(
                    lable: 'Списати',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => BlocProvider.value(
                          value: context.read<WritingOffCubit>(),
                          child: YesOrNoDialog(
                            massage: "Ви дійсно хочете списати товар",
                            yesButton: () {
                              context.read<WritingOffCubit>().sendNom(
                                  state.cellBarcode,
                                  state.nomBarcode,
                                  state.count.toString());

                              focusNode.requestFocus();
                              Navigator.pop(context);
                            },
                            noButton: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      );
                      // showClosingCheck(
                      //   context,
                      //   "Ви дійсно хочете списати товар",
                      //   focusNode,
                      // yesButton: () {
                      //   context.read<WritingOffCubit>().sendNom(
                      //       state.cellBarcode,
                      //       state.nomBarcode,
                      //       state.count.toString());

                      //   focusNode.requestFocus();
                      //   Navigator.pop(context);
                      // },
                      // noButton: () {
                      //   Navigator.pop(context);
                      // },
                      // );
                    },
                    color: AppColors.darkBlue,
                  )
                ],
              );
            }
            return const SizedBox();
          },
        ),
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
        BlocBuilder<WritingOffCubit, WritingOffState>(
          builder: (context, state) {
            return rowValue(state.cell.cell.first.nameCell);
          },
        ),
      ],
    );
  }
}

class ArticleInfo extends StatelessWidget {
  const ArticleInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        rowName('Артикул:'),
        BlocBuilder<WritingOffCubit, WritingOffState>(
          builder: (context, state) {
            return rowValue(state.article);
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
        BlocBuilder<WritingOffCubit, WritingOffState>(
          buildWhen: (previous, current) {
            return previous != current;
          },
          builder: (context, state) {
            return rowValue(state.cell.zone == 1
                ? state.cell.cell.first.quantity.toString()
                : state.qty.toStringAsFixed(0));
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
        BlocBuilder<WritingOffCubit, WritingOffState>(
          buildWhen: (previous, current) {
            return previous != current;
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: SizedBox(
                  width: 200,
                  child: Text(
                    state.cell.zone == 1
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
    return BlocBuilder<WritingOffCubit, WritingOffState>(
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
    builder: (_) => BlocProvider.value(
      value: context.read<WritingOffCubit>(),
      child: CellInfoAlert(
        cell: cell,
        tap: tap,
        cubit: cubit,
      ),
    ),
  );
}
