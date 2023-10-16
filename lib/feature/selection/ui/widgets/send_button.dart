import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/selection_cubit.dart';

class SendButton extends StatelessWidget {
  const SendButton({super.key});

  @override
  Widget build(BuildContext context) {
    final  state =
        context.select((SelectionCubit cubit) => cubit.state);
    final String containerBarcode = state.containerBar;
        final String lastNom = state.lastNom;


    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: ElevatedButton(
        style: const ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll(Color.fromARGB(255, 92, 92, 92)),
                maximumSize: MaterialStatePropertyAll(Size.fromWidth(90))),
            
        child:  Text('Закрити кошик', 
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white)),
        onPressed: () {
          context.read<SelectionCubit>().sendContainer(containerBarcode, lastNom);
          Navigator.pop(context);
        },
      ),
    );
  }
}
