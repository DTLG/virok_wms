import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/inventory/inventory_head/cubit/inventory_head_cubit.dart';
import 'package:virok_wms/route/route.dart';
import 'package:virok_wms/ui/theme/app_theme.dart';
import 'package:virok_wms/ui/widgets/row_element.dart';
import 'package:virok_wms/ui/widgets/table_widgets/table_widgets.dart';

class InventoryHeadPage extends StatelessWidget {
  const InventoryHeadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryHeadCubit(),
      child: const InventoryHeadView(),
    );
  }
}

class InventoryHeadView extends StatelessWidget {
  const InventoryHeadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Інвентаризація'),
      ),
      body: const Padding(
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

    return BlocBuilder<InventoryHeadCubit, InventoryHeadState>(
      builder: (context, state) {
        final docs = state.docs.docs;

        if (state.status.isInitial) {
          context.read<InventoryHeadCubit>().getDocs();
          return const Expanded(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        }

        return Expanded(
          child: ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) => TableElement(
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
                Navigator.pushNamed(context, AppRoutes.inventoryDataPage,
                    arguments: {
                      'headCubit': context.read<InventoryHeadCubit>(),
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
