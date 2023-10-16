import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/selection_cubit.dart';

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class ContainerInput extends StatefulWidget {
  const ContainerInput({super.key});

  @override
  State<ContainerInput> createState() => _ContainerInputState();
}

class _ContainerInputState extends State<ContainerInput> {
  final controller = TextEditingController();

  final focusNode = FocusNode();
  final focusNode1 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: controller,
        autofocus: true,
        focusNode: focusNode1,
        textAlignVertical: TextAlignVertical.bottom,
        textInputAction: TextInputAction.next,
        onSubmitted: (value) async {
          controller.text;
          final status =
              await context.read<SelectionCubit>().getContainer(value);

          if (status == 3) {
            controller.clear();
            focusNode1.requestFocus();
          }
        },
        decoration: const InputDecoration(
          hintText: "Відскануйте кошик",
        ),
      ),
    );
  }
}
