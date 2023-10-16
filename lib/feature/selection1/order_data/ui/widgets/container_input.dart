import 'package:flutter/material.dart';

class ContainerInput extends StatefulWidget {
  const ContainerInput({
    super.key,
  });

  @override
  State<ContainerInput> createState() => _ContainerInputState();
}

class _ContainerInputState extends State<ContainerInput> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        decoration: const InputDecoration(hintText: 'Відскануйте кошик'),
      ),
    );
  }
}
