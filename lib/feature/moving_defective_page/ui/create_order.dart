import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/moving_defective_page/cubit/create_cubit/create_defective_order_page_cubit.dart';
import 'package:virok_wms/ui/theme/app_theme.dart';
import 'package:virok_wms/ui/widgets/row_element.dart';
import 'package:virok_wms/ui/widgets/sound_interface.dart';
import 'package:virok_wms/ui/widgets/table_widgets/table_body_element.dart';
import 'package:virok_wms/ui/widgets/table_widgets/table_head.dart';

SoundInterface soundInterface = SoundInterface();

class CreateDefectiveOrdersPage extends StatelessWidget {
  const CreateDefectiveOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateDefectiveOrderPageCubit(),
      child: MovingDefectiveView(),
    );
  }
}

class MovingDefectiveView extends StatelessWidget {
  MovingDefectiveView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Створення'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
        child: Column(
          children: [
            _TableHead(),
            Expanded(child: Body()),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final barcode = context
                      .read<CreateDefectiveOrderPageCubit>()
                      .state
                      .textController
                      .text;
                  context
                      .read<CreateDefectiveOrderPageCubit>()
                      .setNoms(barcode);
                  Navigator.pop(context);
                },
                child: Text('Завершити'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TableHead extends StatelessWidget {
  const _TableHead();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TableHeads(
      children: [
        RowElement(
          flex: 1,
          value: "№",
          textStyle: theme.textTheme.titleSmall,
        ),
        RowElement(
          flex: 9,
          value: "Номенклатура",
          textStyle: theme.textTheme.titleSmall,
        ),
        RowElement(
          flex: 3,
          value: "Артикул",
          textStyle: theme.textTheme.titleSmall,
        ),
        RowElement(
          flex: 5,
          value: "Комірка",
          textStyle: theme.textTheme.titleSmall,
        ),
        RowElement(
          flex: 2,
          value: "Статус комірки",
          textStyle: theme.textTheme.titleSmall,
        ),
        RowElement(
          flex: 1,
          value: "К-сть",
          textStyle: theme.textTheme.titleSmall,
        ),
      ],
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final MyColors myColors = Theme.of(context).extension<MyColors>()!;

    return BlocBuilder<CreateDefectiveOrderPageCubit,
        CreateDefectiveOrderPageState>(
      builder: (context, state) {
        final cubit = context.read<CreateDefectiveOrderPageCubit>();

        switch (cubit.state.status) {
          case CreateDefectiveOrderPageStatus.initial:
            return AlertDialog(
              title: Text('Зіскануйте Штрих-код'),
              content: TextField(
                autofocus: true,
                controller: cubit.state.textController, // Add controller here
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.none,
                onSubmitted: (value) {
                  context.read<CreateDefectiveOrderPageCubit>().getCell(value);
                },
              ),
              // actions: <Widget>[
              //   TextButton(
              //     onPressed: () {
              //       Navigator.pop(context);
              //     },
              //     child: Text('Скасувати'),
              //   ),
              //   TextButton(
              //     onPressed: () {
              //       final value = cubit.state.textController.text;
              //       context
              //           .read<CreateDefectiveOrderPageCubit>()
              //           .getCell(value);
              //     },
              //     child: Text('Підтвердити'),
              //   ),
              // ],
            );
          case CreateDefectiveOrderPageStatus.loading:
            return Center(child: CircularProgressIndicator());
          case CreateDefectiveOrderPageStatus.loaded:
            return ListView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: cubit.state.noms.length,
              itemBuilder: (context, index) {
                return TableElement(
                  height: 60,
                  dataLenght: cubit.state.noms.length,
                  rowElement: [
                    RowElement(
                      flex: 1,
                      value: (index + 1).toString(),
                      textStyle: theme.textTheme.titleSmall,
                    ),
                    RowElement(
                      flex: 9,
                      value: cubit.state.noms[index].nom,
                      textStyle: theme.textTheme.titleSmall,
                    ),
                    RowElement(
                      flex: 3,
                      value: cubit.state.noms[index].article,
                      textStyle: theme.textTheme.titleSmall,
                    ),
                    RowElement(
                      flex: 5,
                      value: cubit.state.noms[index].cell,
                      textStyle: theme.textTheme.titleSmall,
                    ),
                    RowElement(
                      flex: 2,
                      value: cubit.state.noms[index].statusNom,
                      textStyle: theme.textTheme.titleSmall,
                    ),
                    RowElement(
                      flex: 1,
                      value: cubit.state.noms[index].count.toString(),
                      textStyle: theme.textTheme.titleSmall,
                    ),
                  ],
                  index: index,
                  color: '0' != '0'
                      ? myColors.tableYellow
                      : index % 2 != 0
                          ? myColors.tableDarkColor
                          : myColors.tableLightColor,
                );
              },
            );
          case CreateDefectiveOrderPageStatus.error:
            soundInterface.play(Event.error);
            return Center(
              child: Icon(Icons.error),
            );
          default:
            return Center(
              child: Icon(Icons.error),
            );
        }
      },
    );
  }
}
