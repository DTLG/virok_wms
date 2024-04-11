import 'package:flutter/material.dart';

class NomStatusWidget extends StatelessWidget {
  const NomStatusWidget(
      {super.key, required this.onSelected, required this.nomStatus});

  final Function(String) onSelected;
  final String nomStatus;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'Кондиція',
          child: Text('Кондиція'),
        ),
        const PopupMenuItem(
          value: 'Брак',
          child: Text('Брак'),
        ),
        const PopupMenuItem(
          value: 'Уцінка',
          child: Text('Уцінка'),
        ),
      ],
      onSelected: (value) {
        onSelected(value);
      },
      offset: const Offset(1, -1),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.0))),
      child: Container(
        height: 50,
        width: 110,
        decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 100, 100, 100)),
            borderRadius: BorderRadius.circular(18)),
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Text(nomStatus),
            const Icon(Icons.arrow_drop_down_rounded)
          ],
        ),
      ),
    );
  }
}
