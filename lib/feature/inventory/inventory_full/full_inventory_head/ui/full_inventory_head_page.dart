import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/inventory/inventory_full/full_inventory_head/cubit/full_inventory_head_cubit.dart';
import 'package:virok_wms/route/route.dart';
import 'package:virok_wms/ui/ui.dart';


class FullInventoryHeadPage extends StatelessWidget {
  const FullInventoryHeadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FullInventoryHeadCubit(),
      child: const FullInventoryHeadView(),
    );
  }
}

class FullInventoryHeadView extends StatelessWidget {
  const FullInventoryHeadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Повна інвентаризація'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<FullInventoryHeadCubit>().getDocs();
        },
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 8,
              ),
              _TableHead(),
              TableData()
            ],
          ),
        ),
      ),
    );
  }
}

class _TableHead extends StatelessWidget {
  const _TableHead();

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleSmall;

    return TableHeads(
      children: [
        RowElement(
          flex: 1,
          value: '№',
          textStyle: textStyle,
        ),
        RowElement(
          flex: 3,
          value: 'Документ',
          textStyle: textStyle,
        ),
        RowElement(
          flex: 3,
          value: 'Дата',
          textStyle: textStyle,
        ),
      ],
    );
  }
}

class TableData extends StatelessWidget {
  const TableData({super.key});

  @override
  Widget build(BuildContext context) {
    final MyColors myColors = Theme.of(context).extension<MyColors>()!;

    return BlocBuilder<FullInventoryHeadCubit, FullInventoryHeadState>(
      builder: (context, state) {
        final docs = state.docs.docs;

        if (state.status.isInitial) {
          context.read<FullInventoryHeadCubit>().getDocs();
          return const Expanded(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        }

        return Expanded(
          child: ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) => TableElement(
              bottomMargin: 60,
              dataLenght: docs.length,
              rowElement: [
                RowElement(flex: 1, value: (index + 1).toString()),
                RowElement(flex: 3, value: docs[index].docNumber),
                RowElement(flex: 3, value: docs[index].docDate),
              ],
              index: index,
              color: index % 2 != 0
                  ? myColors.tableDarkColor
                  : myColors.tableLightColor,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.fullInventoryDataPage,
                    arguments: {
                      'headCubit': context.read<FullInventoryHeadCubit>(),
                      'doc': docs[index]
                    });
              },
            ),
          ),
        );
      },
    );
  }
}
