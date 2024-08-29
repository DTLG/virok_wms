import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/moving_defective_page/cubit/read_cubit/moving_defective_cubit.dart';
import 'package:virok_wms/ui/theme/app_theme.dart';
import 'package:virok_wms/ui/widgets/row_element.dart';
import 'package:virok_wms/ui/widgets/table_widgets/table_body_element.dart';
import 'package:virok_wms/ui/widgets/table_widgets/table_head.dart';

import '../cubit/docs_cubit/docs_defect_cubit.dart';
import 'nom_table.dart';

class ReadDefectiveOrdersPage extends StatelessWidget {
  const ReadDefectiveOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MovingDefectiveCubit(),
        ),
        BlocProvider(
          create: (context) => DocsDefectCubit(),
        ),
      ],
      child: const MovingDefectiveView(),
    );
  }
}

class MovingDefectiveView extends StatelessWidget {
  const MovingDefectiveView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Переміщення браку'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<DocsDefectCubit>().getDocs();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Список активних документів переміщення браку',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const _DocsTableHead(),
            const _DocsCustomTable(),
            // const Padding(
            //   padding: EdgeInsets.symmetric(vertical: 16.0),
            //   child: Text('Дані документа переміщення браку',
            //       style: TextStyle(
            //         fontWeight: FontWeight.bold,
            //       )),
            // ),
            // const _NomTableHead(),
            // const _NomCustomTable(),
          ],
        ),
      ),
    );
  }
}

class _DocsTableHead extends StatelessWidget {
  const _DocsTableHead();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TableHeads(
      children: [
        RowElement(
          flex: 4,
          value: "№",
          textStyle: theme.textTheme.titleSmall,
        ),
        RowElement(
          flex: 9,
          value: "Дата",
          textStyle: theme.textTheme.titleSmall,
        ),
        RowElement(
          flex: 5,
          value: "Комірка",
          textStyle: theme.textTheme.titleSmall,
        ),
      ],
    );
  }
}

class _DocsCustomTable extends StatelessWidget {
  const _DocsCustomTable();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final MyColors myColors = Theme.of(context).extension<MyColors>()!;

    return Expanded(
      child: BlocBuilder<DocsDefectCubit, DocsDefectState>(
        builder: (context, state) {
          final docsCubit = context.read<DocsDefectCubit>();
          final movingCubit = context.read<MovingDefectiveCubit>();

          switch (state.status) {
            case DocsDefectStatus.initial:
              docsCubit.getDocs();
              return const SizedBox();
            case DocsDefectStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case DocsDefectStatus.loaded:
              return ListView.builder(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: state.docs.length,
                itemBuilder: (context, index) {
                  return TableElement(
                    height: 60,
                    dataLenght: state.docs.length,
                    rowElement: [
                      RowElement(
                        flex: 4,
                        value: state.docs[index].number,
                        textStyle: theme.textTheme.titleSmall,
                      ),
                      RowElement(
                        flex: 9,
                        value: state.docs[index].date,
                        textStyle: theme.textTheme.titleSmall,
                      ),
                      RowElement(
                        flex: 5,
                        value: state.docs[index].cell,
                        textStyle: theme.textTheme.titleSmall,
                      ),
                    ],
                    index: index,
                    onTap: () {
                      movingCubit
                          .getMovingData(docsCubit.state.docs[index].number);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NomTablePage(
                            barcode: docsCubit.state.docs[index].number,
                          ),
                        ),
                      );
                    },
                    color: index % 2 != 0
                        ? myColors.tableDarkColor
                        : myColors.tableLightColor,
                  );
                },
              );
            case DocsDefectStatus.error:
              return const Center(child: Icon(Icons.error));
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
