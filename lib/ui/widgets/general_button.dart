import 'package:flutter/material.dart';
import 'package:virok_wms/ui/theme/theme.dart';

class GeneralButton extends StatelessWidget {
  const GeneralButton(
      {super.key,
      required this.lable,
      required this.onPressed,
      this.color = AppColors.darkRed,
      this.padding = true});
  final String lable;
  final bool padding;
  final VoidCallback? onPressed;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding == true ? 8 : 0),
      child: ElevatedButton(
        onPressed: onPressed,
        style:  ButtonStyle(
            fixedSize: const MaterialStatePropertyAll(Size(200, 50)),
             backgroundColor:
                      MaterialStatePropertyAll(color),
            ),
        child: Text(
          lable,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
