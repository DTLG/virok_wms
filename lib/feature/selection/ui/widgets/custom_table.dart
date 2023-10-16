import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/models.dart';
import '../../../../../ui/widgets/alerts.dart';
import '../../../../../ui/widgets/row_element.dart';
import '../../cubit/selection_cubit.dart';

class CustomTable extends StatelessWidget {
  const CustomTable({super.key, required this.noms});

  final List<Nom> noms;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: noms.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              showCountAlert(context, noms[index]);
            },
            child: CustomTableRow(
              index: index,
              lastIndex: noms.length - 1,
              nom: noms[index],
            ),
          );
        },
      ),
    );
  }
}

class CustomTableRow extends StatelessWidget {
  const CustomTableRow(
      {super.key,
      required this.index,
      required this.lastIndex,
      required this.nom});
  final Nom nom;
  final int index;
  final int lastIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: lastIndex == index ? 8 : 0),
      height: 45,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
          color: index % 2 == 0 ? Colors.grey[200] : Colors.white,
          border: const Border.symmetric(
              vertical: BorderSide(width: 1),
              horizontal: BorderSide(width: 0.5)),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(lastIndex == index ? 8 : 0),
              bottomRight: Radius.circular(lastIndex == index ? 8 : 0))),
      child: Row(
        children: [
          RowElement(
            flex: 7,
            value: nom.name,
            textStyle: theme.textTheme.labelSmall
                ?.copyWith(letterSpacing: 0.5, overflow: TextOverflow.ellipsis),
          ),
          RowElement(
            flex: 4,
            value: nom.article,
            textStyle: theme.textTheme.labelMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          RowElement(
            flex: 4,
            value: nom.nameCell,
            textStyle: theme.textTheme.labelMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          RowElement(
            flex: 2,
            value: nom.qty.toString(),
            textStyle: theme.textTheme.labelMedium,
          ),
          RowElement(
            flex: 2,
            value: nom.count.toString(),
            textStyle: theme.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}

void showCountAlert(BuildContext context, Nom nom, ) {
  showDialog(
      context: context,
      builder: (_) {
        return BlocProvider.value(
            value: context.read<SelectionCubit>(),
            child: InputCountAlert(
              onPressed: () {
                final String count =
                    context.read<SelectionCubit>().state.count;
                final String containerBar =
                    context.read<SelectionCubit>().state.containerBar;

                Navigator.pop(context);
                final String cell =
                    context.read<SelectionCubit>().state.cell;
                context
                    .read<SelectionCubit>()
                    .sendNoms(nom.barcode, count, containerBar, cell);
              },
              onChanged: (value) {
                if (value.split('').first == '-') {
                  Alerts(context: context, msg: 'Введене відємне число')
                      .showError();
                  value = '';
                } else {
                  context.read<SelectionCubit>().writeCount(value);
                }
              },
            ));
      });
}

