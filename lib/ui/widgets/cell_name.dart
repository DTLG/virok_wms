// import 'package:adaptive_theme/adaptive_theme.dart';
// import 'package:flutter/material.dart';

// class CellName extends StatelessWidget {
//   const CellName(
//       {super.key, required this.flex, required this.value, this.fontSize = 12});

//   final int flex;
//   final String value;
//   final double fontSize;

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(flex: flex, child: cellName(value, fontSize, context));
//   }
// }




// Widget cellName(String cell, double fontSize, BuildContext context) {

//   String zone = '';
// String rangr = '';
// String cell = '';

// List symbolList = cell.split('');


// for(var i = 0;i<symbolList.length;i++){
// if(symbolList[i]== '-'){
//   zone = symbolList[i-1];
// }

// print(zone);
// }




  // List<String> res = [];

  // try {
  //   if (cell.indexOf('M') == 0) {
  //     final list = cell.split('');

  //     for (var i = 0; i < list.length; i++) {
  //       if (list[i] == '-') {
  //         res.add('${list[i + 1]}${list[i + 2]}');
  //       } else {}
  //     }

  //     return Text.rich(TextSpan(children: [
  //       TextSpan(text: 'M-${res[0]}-', style: TextStyle(fontSize: fontSize)),
  //       TextSpan(
  //           text: res[1],
  //           style:
  //               TextStyle(fontWeight: FontWeight.w700, fontSize: fontSize + 1)),
  //       TextSpan(
  //           text: '-${res[2]}-${res[3]}-${res[4]}',
  //           style: TextStyle(fontSize: fontSize))
  //     ]));
  //   } else {
  //     final list = cell.split('');
  //     res.add('${list[0]}${list[1]}');
  //     for (var i = 0; i < list.length; i++) {
  //       if (list[i] == '-') {
  //         res.add('${list[i + 1]}${list[i + 2]}');
  //       }
  //     }

  //     final themeMode = AdaptiveTheme.of(context).mode;

  //     return RichText(
  //         textAlign: TextAlign.center,
  //         text: TextSpan(
  //             style: TextStyle(
  //                 color: themeMode.isLight ? Colors.black : Colors.white),
  //             children: [
  //               TextSpan(
  //                   text: res[0],
  //                   style: const TextStyle(
  //                       fontWeight: FontWeight.w900, fontSize: 14)),
  //               TextSpan(
  //                   text: '-${res[1]}-${res[2]}-${res[3]}',
  //                   style: const TextStyle(fontSize: 13))
  //             ]));
  //   }
  // } catch (e) {
  //   return Text(
  //     cell,
  //     style: TextStyle(fontSize: fontSize + 1),
  //     textAlign: TextAlign.center,
  //   );
  // }
// }
