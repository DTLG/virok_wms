import 'package:flutter/material.dart';

class DialogHead extends StatelessWidget {
  const DialogHead(
      {super.key,
      required this.title,
      required this.onPressed,
      this.textStyle});

  final String title;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(
          width: 50,
        ),
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textStyle ??
              TextStyle(
                  fontSize: title.length.toSize, fontWeight: FontWeight.w500),
        ),
        IconButton(onPressed: onPressed, icon: const Icon(Icons.close)),
      ],
    );
  }
}

extension on int {
  double get toSize {
    switch (this) {
      case < 9:
        return 30;
      case < 12:
        return 25;
      case < 15:
        return 22;
      case < 20:
        return 18;
      default:
        return 18;
    }
  }
}
