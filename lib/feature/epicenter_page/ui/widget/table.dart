import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/epicenter_page/cubit/epicenter_cubit.dart';
import 'package:virok_wms/feature/epicenter_page/cubit/noms_page_cubit.dart';
import 'package:virok_wms/feature/epicenter_page/model/nom.dart';
import 'package:virok_wms/feature/moving_defective_page/widget/toast.dart';
import 'package:virok_wms/ui/widgets/widgets.dart';
import 'package:virok_wms/ui/theme/theme.dart';

class CustomTable extends StatelessWidget {
  const CustomTable(
      {super.key, required this.noms, required this.docId, required this.guid});

  final List<Nom> noms;
  final String docId;
  final String guid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final MyColors myColors = Theme.of(context).extension<MyColors>()!;
    return Expanded(
      child: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: noms.length,
        itemBuilder: (context, index) {
          final nom = noms[index];

          return InkWell(
            onTap: () => _handleNomTap(context, nom, docId),
            child: CustomTableRow(
              index: index,
              lastIndex: noms.length - 1,
              nom: nom,
              onLongPress: () {
                if (nom.countNeed > 8) {
                  final cubit = context.read<NomsPageCubit>();
                  _showCountInputDialog(context, nom, cubit);
                }
              },
            ),
          );
        },
      ),
    );
  }

  void _handleNomTap(BuildContext context, Nom nom, String docId) {
    if (nom.countNeed < nom.countScanned) {
      final barcode = nom.barcodes.isEmpty ? '' : nom.barcodes.first.barcode;

      if (barcode.isEmpty) {
        Alerts(msg: 'Вибраному товару не присвоєний штрихкод', context: context)
            .showError();
        return;
      }

      showNomInput(context, nom.article, docId, barcode, Nom.empty);
      context.read<NomsPageCubit>().getNoms(docId);
    }
  }

  void _showCountInputDialog(
      BuildContext context, Nom nom, NomsPageCubit cubit) {
    final TextEditingController countController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Введіть кількість для ${nom.tovar}'),
          content: TextField(
            controller: countController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Кількість'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Скасувати'),
            ),
            TextButton(
              onPressed: () {
                final int count = int.tryParse(countController.text) ?? 0;
                if (count > 0 && (count + nom.countScanned <= nom.countNeed)) {
                  cubit.docScan(guid, nom.barcodes.first.barcode, count);
                } else {
                  showToast('Невірно введена кількість');
                }

                Navigator.of(context).pop();
              },
              child: const Text('Підтвердити'),
            ),
          ],
        );
      },
    );
  }
}

class CustomTableRow extends StatelessWidget {
  const CustomTableRow({
    super.key,
    required this.index,
    required this.lastIndex,
    required this.nom,
    required this.onLongPress,
  });

  final Nom nom;
  final int index;
  final int lastIndex;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isLastRow = index == lastIndex;

    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.only(bottom: isLastRow ? 8 : 0),
        height: 45,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: nom.countNeed == nom.countScanned
              ? const Color.fromARGB(255, 132, 255, 142)
              : const Color.fromARGB(248, 255, 255, 91),
          border: const Border.symmetric(
            vertical: BorderSide(width: 1),
            horizontal: BorderSide(width: 0.5),
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(isLastRow ? 15 : 0),
            bottomRight: Radius.circular(isLastRow ? 15 : 0),
          ),
        ),
        child: Row(
          children: [
            RowElement(
              flex: 8,
              value: nom.tovar,
              textStyle: theme.textTheme.labelSmall?.copyWith(
                letterSpacing: 0.5,
                overflow: TextOverflow.ellipsis,
                fontSize: 9,
              ),
            ),
            RowElement(
              flex: 2,
              value: nom.article,
              textStyle: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 10,
              ),
            ),
            RowElement(
              flex: 2,
              value: nom.countNeed.toString(),
              textStyle: theme.textTheme.labelMedium,
            ),
            RowElement(
              flex: 2,
              value: nom.countScanned.toString(),
              textStyle: theme.textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}

void showNomInput(BuildContext context, String cellBarcode, String docId,
    String nomBarcode, Nom nom) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => BlocProvider.value(
      value: context.read<NomsPageCubit>(),
      child: NomInputDialog(
        docId: docId,
        nomBarcode: nomBarcode,
        cellBarcode: cellBarcode,
        nom: nom,
      ),
    ),
  );
}

class NomInputDialog extends StatelessWidget {
  const NomInputDialog({
    Key? key,
    required this.docId,
    required this.nomBarcode,
    required this.cellBarcode,
    required this.nom,
  }) : super(key: key);

  final String docId;
  final String nomBarcode;
  final String cellBarcode;
  final Nom nom;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(nom.tovar),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Enter details for ${nom.tovar}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
