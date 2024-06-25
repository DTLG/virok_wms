import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SquareButton extends StatelessWidget {
  const SquareButton(
      {super.key,
      required this.lable,
      required this.color,
      required this.onTap,
      this.lableWidth = 0,
      this.imagePath = '',
     });

  final String lable;
  final Color color;
  final GestureTapCallback? onTap;
  final String imagePath;
  final double lableWidth;

  @override
  Widget build(BuildContext context) {
    final double textWith = lableWidth == 0
        ? lable.length > 14
            ? 135
            : 200
        : lableWidth;

    lable.length > 12 ? 135 : 200;
    final textStyle = GoogleFonts.oswald(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w900,
        height: 1.1,
        shadows: [
          const Shadow(offset: Offset(-1, -1), color: Colors.black),
          const Shadow(offset: Offset(1, -1), color: Colors.black),
          const Shadow(offset: Offset(1, 1), color: Colors.black),
          const Shadow(offset: Offset(-1, 1), color: Colors.black),
        ]);
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: color,
            image: imagePath.isNotEmpty
                ? DecorationImage(image: AssetImage(imagePath))
                : null,
            borderRadius: BorderRadius.circular(5)),
        margin: const EdgeInsets.all(3),
        height: double.infinity,
        child: Align(
          alignment: const Alignment(0, -0.34),
          child: SizedBox(
            child: SizedBox(
              width: textWith,
              child: Text(
                lable,
                style: textStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Color lighter(Color color) {
  return Color.fromARGB(
      color.alpha, color.red + 25, color.green + 20, color.blue);
}

extension A on int {
  get buttonColor {
    switch (this) {
      case 0 || 3 || 4 || 7 || 8:
        return 'w';
      case 1 || 2 || 5 || 6 || 9 || 10:
        return 'r';
    }
  }
}
