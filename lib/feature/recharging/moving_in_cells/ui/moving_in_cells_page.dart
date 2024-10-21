import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/home_page/cubit/home_page_cubit.dart';
import 'package:virok_wms/feature/recharging/moving_in_cells/cubit/moving_in_cells_cubit.dart';
import 'package:virok_wms/models/check_cell.dart';
import 'package:virok_wms/ui/widgets/sound_interface.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';

import '../../../../ui/custom_keyboard/keyboard.dart';

final SoundInterface _soundInterface = SoundInterface();

class MovingInCellsPage extends StatelessWidget {
  const MovingInCellsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovingInCellsCubit(),
      child: const MovingInCellsView(),
    );
  }
}

class MovingInCellsView extends StatelessWidget {
  const MovingInCellsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text(
            'Переміщення між комірками',
            maxLines: 2,
            textAlign: TextAlign.center,
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
                  context.read<MovingInCellsCubit>().clear();
                },
              ),
            )
          ],
        ),
        body: BlocConsumer<MovingInCellsCubit, MovingInCellsState>(
          listener: (context, state) {
            if (state.status.isNotFound) {
              Alerts(msg: state.errorMassage, context: context).showError();
            }
            if (state.status.isPlacement) {
              Alerts(msg: "Розміщено", context: context, color: Colors.green)
                  .showToast();
            }
          },
          builder: (context, state) {
            if (state.status.isFailure) {
              _soundInterface.play(Event.error);

              return Center(
                  child: WentWrong(
                onPressed: () {
                  context.read<MovingInCellsCubit>().clear();
                },
                errorDescription: state.errorMassage,
              ));
            }
            if (state.status.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Body(
              title: state.isPlacement ? 'Розміщення' : 'Списання',
            );
          },
        ),
        bottomSheet: BlocBuilder<MovingInCellsCubit, MovingInCellsState>(
          builder: (context, state) {
            return state.status.isFailure ||
                    state.cellPut.isEmpty ||
                    state.cellTake.isEmpty ||
                    state.nom == Nom.empty
                ? const SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GeneralButton(
                          lable: 'Списати та розмістити',
                          onPressed: () {
                            if (state.status.isLoading) return;
                            context.read<MovingInCellsCubit>().send();
                          })
                    ],
                  );
          },
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        primary: false,
        children: [
          const SizedBox(
            height: 5,
          ),
          const CellTakeInput(),
          const SizedBox(
            height: 5,
          ),
          const Row(
            children: [
              Expanded(child: NomInput()),
              SizedBox(
                width: 5,
              ),
              MonualCountIncrementButton()
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          BlocBuilder<MovingInCellsCubit, MovingInCellsState>(
            builder: (context, state) {
              return Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      CeelInfo(
                        cell: state.cellTakeName,
                      ),
                      QuantityInfo(
                          qty: state.nom.qty == 0
                              ? ''
                              : state.nom.qty.toString()),
                      NomInfo(
                        article: state.nom.article,
                      ),
                      NomNameInfo(
                        name: state.nom.name,
                      )
                    ],
                  ));
            },
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<MovingInCellsCubit, MovingInCellsState>(
                builder: (context, state) {
                  return NomStatusWidget(
                    nomStatus: state.nomStatus,
                    onSelected: (value) {
                      context.read<MovingInCellsCubit>().setNomStatus(value);
                    },
                  );
                },
              ),
              const SizedBox(
                height: 120,
                width: 220,
                child: FittedBox(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: CountInfo(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const CellPutInput()
        ],
      ),
    );
  }
}

class CellTakeInput extends StatefulWidget {
  const CellTakeInput({
    super.key,
  });

  @override
  State<CellTakeInput> createState() => _CellTakeInputState();
}

class _CellTakeInputState extends State<CellTakeInput> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final state = context.select((MovingInCellsCubit cubit) => cubit.state);
    controller.text = state.cellTake;
    final bool cameraScaner = context.read<HomePageCubit>().state.cameraScaner;
    final status = state.status;
    if (cameraScaner != true) {
      status.isInitial || status.isPlacement ? controller.clear() : controller;
      status.isInitial || status.isPlacement
          ? focusNode.requestFocus()
          : focusNode;
    }
    return SizedBox(
        height: 50,
        child: TextField(
          autofocus: cameraScaner ? false : true,
          textInputAction: TextInputAction.next,
          focusNode: focusNode,
          controller: controller,
          textAlignVertical: TextAlignVertical.bottom,
          onSubmitted: (value) async {
            final res =
                await context.read<MovingInCellsCubit>().getCellTake(value);
            res ? controller : controller.clear();
            res ? () {} : focusNode.requestFocus();
          },
          decoration: InputDecoration(
              labelText: 'Списати з',
              hintText: 'Відскануйте комірку',
              suffixIcon: cameraScaner
                  ? CameraScanerButton(
                      scan: (value) async {
                        await context
                            .read<MovingInCellsCubit>()
                            .getCellTake(value);
                      },
                    )
                  : null),
        ));
  }
}

class CellPutInput extends StatefulWidget {
  const CellPutInput({
    super.key,
  });

  @override
  State<CellPutInput> createState() => _CellPutInputState();
}

class _CellPutInputState extends State<CellPutInput> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final state = context.select((MovingInCellsCubit cubit) => cubit.state);
    controller.text = state.cellPut;
    final status = state.status;
    final bool cameraScaner = context.read<HomePageCubit>().state.cameraScaner;

    if (cameraScaner != true) {
      status.isInitial || status.isPlacement ? controller.clear() : controller;
    }
    return SizedBox(
        height: 50,
        child: TextField(
          focusNode: focusNode,
          controller: controller,
          textAlignVertical: TextAlignVertical.bottom,
          onSubmitted: (value) async {
            final res =
                await context.read<MovingInCellsCubit>().getCellPut(value);
            res ? controller : controller.clear();
            res ? () {} : focusNode.requestFocus();
          },
          decoration: InputDecoration(
              labelText: 'Розмістити в',
              hintText: 'Відскануйте комірку',
              suffixIcon: cameraScaner
                  ? CameraScanerButton(scan: (value) async {
                      final res = await context
                          .read<MovingInCellsCubit>()
                          .getCellPut(value);
                      res ? controller : controller.clear();
                      res ? () {} : focusNode.requestFocus();
                    })
                  : null),
        ));
  }
}

class NomInput extends StatefulWidget {
  const NomInput({super.key});

  @override
  State<NomInput> createState() => _NomInputState();
}

class _NomInputState extends State<NomInput> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final bool cameraScaner = context.read<HomePageCubit>().state.cameraScaner;

    return SizedBox(
        height: 50,
        child: TextField(
          focusNode: focusNode,
          controller: controller,
          textAlignVertical: TextAlignVertical.bottom,
          onSubmitted: (value) {
            context.read<MovingInCellsCubit>().scanNom(value);
            controller.clear();
            focusNode.requestFocus();
          },
          decoration: InputDecoration(
              hintText: 'Відскануйте товар',
              suffixIcon: cameraScaner
                  ? CameraScanerButton(scan: (value) {
                      context.read<MovingInCellsCubit>().scanNom(value);
                    })
                  : null),
        ));
  }
}

class MonualCountIncrementButton extends StatefulWidget {
  const MonualCountIncrementButton({super.key});

  @override
  State<MonualCountIncrementButton> createState() =>
      _MonualCountIncrementButtonState();
}

class _MonualCountIncrementButtonState
    extends State<MonualCountIncrementButton> {
  final countController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final nom = context.select((MovingInCellsCubit cubit) => cubit.state.nom);
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
              nom == Nom.empty ? Colors.grey : Colors.green),
        ),
        onPressed: () {
          if (nom == Nom.empty) {
          } else {
            showDialog(
              context: context,
              builder: (_) => Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(),
                  AlertDialog(
                    content: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 90,
                          child: TextField(
                            autofocus: true,
                            controller: countController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    actionsAlignment: MainAxisAlignment.center,
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            if (countController.text.isNotEmpty) {
                              context
                                  .read<MovingInCellsCubit>()
                                  .manualCountIncrement(
                                      int.parse(countController.text));
                              countController.clear();
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Продовжити'))
                    ],
                  ),
                  Keyboard(controller: countController)
                ],
              ),
            );
          }
        },
        child: const SizedBox(
            width: 70,
            child: Text(
              'Ввести кількість',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            )));
  }
}

class CeelInfo extends StatelessWidget {
  const CeelInfo({super.key, required this.cell});

  final String cell;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [rowName('Комірка №:'), rowValue(cell)],
    );
  }
}

class NomInfo extends StatelessWidget {
  const NomInfo({super.key, required this.article});

  final String article;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [rowName('Артикул:'), rowValue(article)],
    );
  }
}

class QuantityInfo extends StatelessWidget {
  const QuantityInfo({super.key, required this.qty});

  final String qty;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [rowName('Кількість в комірці:'), rowValue(qty)],
    );
  }
}

class NomNameInfo extends StatelessWidget {
  const NomNameInfo({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        rowName('Назва товару:'),
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: SizedBox(
              width: 200,
              child: Text(
                name,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              )),
        )
      ],
    );
  }
}

Widget rowName(String name) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
    child: Text(
      name,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    ),
  );
}

Widget rowValue(String value) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
    child: Text(
      value,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    ),
  );
}

class CountInfo extends StatelessWidget {
  const CountInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovingInCellsCubit, MovingInCellsState>(
      builder: (context, state) {
        return Text(
          state.count.toString(),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        );
      },
    );
  }
}
