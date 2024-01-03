import 'package:flutter/material.dart';

class BarcodeInput extends StatefulWidget {
  const BarcodeInput({
    super.key,
  });

  @override
  State<BarcodeInput> createState() => _BarcodeInputState();
}

class _BarcodeInputState extends State<BarcodeInput> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        autofocus: true,
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        decoration: const InputDecoration(hintText: 'Відскануйте товар'),
      ),
    );
  }
}
