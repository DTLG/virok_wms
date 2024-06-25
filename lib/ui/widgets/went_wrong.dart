import 'package:flutter/material.dart';

class WentWrong extends StatelessWidget {
  const WentWrong({super.key,  this.onPressed,this.errorMassage = '', this.errorDescription = '', this.buttonTrue = true});

  final VoidCallback? onPressed;
  final String errorMassage;
  final String errorDescription;
  final bool buttonTrue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        const Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 60,
        ),
        const SizedBox(
          height: 15,
        ),
        Text(

          errorMassage.isEmpty?
          'Відсутній звязок з сервером!':errorMassage,
          style: theme.textTheme.bodyLarge?.copyWith(fontSize: 17),
        ),
        const SizedBox(height: 20,),
        buttonTrue ?ElevatedButton(onPressed: onPressed, child: const Text('Спробувати ще раз')):const SizedBox(),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(errorDescription, textAlign: TextAlign.center,style: const TextStyle(color: Colors.grey),),
        )
      ],
    );
  }
}
