import 'package:flutter/material.dart';
import '../../../ui/widgets/widgets.dart';
import '../placement_writeing_off_repository/model/cell_model.dart';

Widget rowName(String name) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
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

void showClosingCheck(BuildContext context, Color color, String massage,
    VoidCallback? yesButton, VoidCallback? noButton) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(
          massage,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceAround,
        actions: [
          Row(
            children: [
              Expanded(
                  child: GeneralButton(
                      color: color, onPressed: yesButton, lable: 'Так')),
              Expanded(
                  child: GeneralButton(
                      color: color,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      lable: 'Ні')),
            ],
          )
        ],
        contentPadding: EdgeInsets.all(10),
        actionsPadding: EdgeInsets.zero,
      );
    },
  );
}

class CellInfoAlert extends StatelessWidget {
  const CellInfoAlert(
      {super.key, required this.cell, required this.tap, required this.cubit});
  final Cell cell;
  final bool tap;
  final cubit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return AlertDialog(
      icon: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            width: 50,
          ),
          Text(
            cell.cell.first.nameCell,
            style: theme.titleLarge,
          ),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close))
        ],
      ),
      iconPadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
      content: cell.cell.first.name.isEmpty
          ? Text(
              'Комірка вільна',
              style: theme.titleMedium,
              textAlign: TextAlign.center,
            )
          : SizedBox(
              height: cell.cell.length * 70,
              child: ListView.separated(
                itemCount: cell.cell.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 0,
                ),
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 70,
                    child: ListTile(
                      enabled: tap,
                      onTap: () {
                        if (tap == true) {
                          cubit.manualAddNom(cell.cell[index]);
                          Navigator.pop(context);
                        } else {}
                      },
                      title: Text(
                        cell.cell[index].name,
                        style: theme.titleSmall!.copyWith(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Text(
                          cell.cell[index].article,
                          style: theme.titleSmall!.copyWith(
                              color: const Color.fromARGB(255, 31, 87, 226)),
                        ),
                      ),
                      trailing: Text(
                        cell.cell[index].quantity.toString(),
                        style: theme.titleSmall!.copyWith(fontSize: 15),
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  );
                },
              )),
    );
  }
}
