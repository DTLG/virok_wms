import 'package:flutter/material.dart';

class Keyboard extends StatelessWidget {
  const Keyboard({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 116, 116, 116),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          children: [
            Row(
              children: [
                KeyboardButton(
                  title: '1',
                  controller: controller,
                ),
                KeyboardButton(
                  title: '2',
                  controller: controller,
                ),
                KeyboardButton(
                  title: '3',
                  controller: controller,
                ),
              ],
            ),
            Row(
              children: [
                KeyboardButton(
                  title: '4',
                  controller: controller,
                ),
                KeyboardButton(
                  title: '5',
                  controller: controller,
                ),
                KeyboardButton(
                  title: '6',
                  controller: controller,
                ),
              ],
            ),
            Row(
              children: [
                KeyboardButton(
                  title: '7',
                  controller: controller,
                ),
                KeyboardButton(
                  title: '8',
                  controller: controller,
                ),
                KeyboardButton(
                  title: '9',
                  controller: controller,
                ),
              ],
            ),
            Row(
              children: [
                KeyboardButton(
                  title: '',
                  controller: controller,
                  elevation: 0,
                  color: Colors.transparent,
                ),
                KeyboardButton(
                  title: '0',
                  controller: controller,
                ),
                KeyboardButton(
                  controller: controller,
                  removeIcon: true,
                  color: Colors.transparent,
                  elevation: 0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class KeyboardButton extends StatelessWidget {
  const KeyboardButton(
      {super.key,
      this.title = '',
      this.removeIcon = false,
      this.color = Colors.white,
      this.elevation = 3,
      required this.controller});

  final String title;
  final bool removeIcon;
  final Color color;
  final double elevation;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(3.0),
      child: ElevatedButton(
          onPressed: () {
            if (removeIcon == false) {
              controller.text += title;
            } else {
              List<String> a = controller.text.split('');
              a.isEmpty ? () {} : a.removeLast();

              controller.text = a.join();
            }
          },
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(color),
              padding: const MaterialStatePropertyAll(EdgeInsets.zero),
              minimumSize: const MaterialStatePropertyAll(Size(100, 45)),
              elevation: MaterialStatePropertyAll(elevation),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ))),
          child: removeIcon
              ? const Icon(
                  Icons.backspace_outlined,
                  color: Colors.black,
                )
              : Text(
                  title,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w400),
                )),
    ));
  }
}
