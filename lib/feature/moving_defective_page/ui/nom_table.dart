import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/moving_defective_page/cubit/read_cubit/moving_defective_cubit.dart';
import 'package:virok_wms/ui/theme/app_theme.dart';
import 'package:virok_wms/ui/widgets/row_element.dart';
import 'package:virok_wms/ui/widgets/sound_interface.dart';
import 'package:virok_wms/ui/widgets/table_widgets/table_body_element.dart';
import 'package:virok_wms/ui/widgets/table_widgets/table_head.dart';

SoundInterface soundInterface = SoundInterface();

class NomTablePage extends StatelessWidget {
  const NomTablePage({super.key, required this.barcode});
  final String barcode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovingDefectiveCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Номенклатура переміщення браку'),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _NomTableHead(),
              _NomCustomTable(barcode),
            ],
          ),
        ),
      ),
    );
  }
}

class _NomTableHead extends StatelessWidget {
  const _NomTableHead();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TableHeads(
      children: [
        RowElement(
          flex: 1,
          value: "№",
          textStyle: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
        ),
        RowElement(
          flex: 9,
          value: "Номенклатура",
          textStyle: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
        ),
        RowElement(
          flex: 3,
          value: "Артикул",
          textStyle: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
        ),
        RowElement(
          flex: 2,
          value: "Статус комірки",
          textStyle: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
        ),
        RowElement(
          flex: 1,
          value: "К-сть",
          textStyle: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
        ),
      ],
    );
  }
}

class _NomCustomTable extends StatelessWidget {
  _NomCustomTable(
    this.docNum,
  );
  final String docNum;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final MyColors myColors = Theme.of(context).extension<MyColors>()!;

    return Expanded(
      child: BlocBuilder<MovingDefectiveCubit, MovingDefectiveState>(
        builder: (context, state) {
          final cubit = context.read<MovingDefectiveCubit>();

          switch (state.status) {
            case MovingDefectiveStatus.initial:
              cubit.getMovingData(docNum);
              return const SizedBox();
            case MovingDefectiveStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case MovingDefectiveStatus.loaded:
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: state.noms.length,
                      itemBuilder: (context, index) {
                        return TableElement(
                          height: 60,
                          dataLenght: state.noms.length,
                          rowElement: [
                            RowElement(
                              flex: 1,
                              value: (index + 1).toString(),
                              textStyle: theme.textTheme.bodyMedium
                                  ?.copyWith(fontSize: 12),
                            ),
                            RowElement(
                              flex: 9,
                              value: state.noms[index].nom,
                              textStyle: theme.textTheme.bodyMedium
                                  ?.copyWith(fontSize: 12),
                            ),
                            RowElement(
                              flex: 3,
                              value: state.noms[index].article,
                              textStyle: theme.textTheme.bodyMedium
                                  ?.copyWith(fontSize: 12),
                            ),
                            RowElement(
                              flex: 2,
                              value: state.noms[index].statusNom,
                              textStyle: theme.textTheme.bodyMedium
                                  ?.copyWith(fontSize: 12),
                            ),
                            RowElement(
                              flex: 1,
                              value: state.noms[index].count.toString(),
                              textStyle: theme.textTheme.bodyMedium
                                  ?.copyWith(fontSize: 12),
                            ),
                          ],
                          index: index,
                          color: index % 2 != 0
                              ? myColors.tableDarkColor
                              : myColors.tableLightColor,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Зіскануйте Штрих-код'),
                              content: TextField(
                                autofocus: true,
                                controller: cubit.state.textController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.none,
                                onSubmitted: (value) {
                                  cubit.confirmMoving(value, docNum);
                                  Navigator.pop(context);
                                },
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Скасувати'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    final value =
                                        cubit.state.textController.text;
                                    cubit.confirmMoving(value, docNum);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Підтвердити'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Перемістити в комірку'),
                    ),
                  ),
                ],
              );
            case MovingDefectiveStatus.error:
              soundInterface.play(Event.error);
              Navigator.pop(context);
              return const Center(child: Icon(Icons.error));
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
