import 'package:flutter/material.dart';
import 'package:virok_wms/ui/ui.dart';

class AppBarButton extends StatelessWidget {
  const AppBarButton({
    super.key,
    this.onPressed,
    required this.title,
  });
  final VoidCallback? onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(AppColors.darkBlue)),
        child: SizedBox(
            width: 75,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall!.copyWith(color: Colors.white),
            )),
      ),
    );
  }
}
