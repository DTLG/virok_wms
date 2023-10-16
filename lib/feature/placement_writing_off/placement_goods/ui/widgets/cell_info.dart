// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../cubit/placement_goods_cubit.dart';

// class CeelInfo extends StatelessWidget {
//   const CeelInfo({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             rowName('Комірка №:'),
//             BlocBuilder<PlacementGoodsCubit, PlacementGoodsState>(
//               builder: (context, state) {
//                 if (state.status.isSuccess) {
//                   return rowValue(state.cell.nameCell);
//                 }
//                 if (state.status.isLoading) {
//                   return const CupertinoActivityIndicator();
//                 }
//                 return const Text('');
//               },
//             )
//           ],
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             rowName('Кількість:'),
//             BlocBuilder<PlacementGoodsCubit, PlacementGoodsState>(
//               builder: (context, state) {
//                 if (state.status.isSuccess) {
//                   return rowValue(state.cell.quantity.toString());
//                 }
//                 if (state.status.isLoading) {
//                   return const CupertinoActivityIndicator();
//                 }
//                 return const Text('');
//               },
//             )
//           ],
//         ),
//       ],
//     );
//   }
// }

// class NomInfo extends StatelessWidget {
//   const NomInfo({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             rowName('Назва товару:'),
//             BlocBuilder<PlacementGoodsCubit, PlacementGoodsState>(
//               // buildWhen: (previous, current) {
//               //   var a = true;
//               //   if (current.ceel!.status != 3 && current.status.isSuccess) {
//               //     a = true;
//               //   } else if (current.ceel!.status == 0 &&
//               //       current.status.isNotFound) {
//               //     a = true;
//               //   } else {
//               //     a = false;
//               //   }
//               //   return a;
//               // },
//               builder: (context, state) {
//                 if (state.status.isSuccess) {
//                   return Expanded(
//                       child: Padding(
//                     padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
//                     child: Text(
//                       state.cell.name,
//                       overflow: TextOverflow.ellipsis,
//                       textAlign: TextAlign.right,
//                       maxLines: 3,
//                       style: const TextStyle(
//                           fontWeight: FontWeight.w600, fontSize: 16),
//                     ),
//                   ));
//                 }
//                 if (state.status.isLoading) {
//                   return const CupertinoActivityIndicator();
//                 }
//                 return const Text('');
//               },
//             )
//           ],
//         ),
//       ],
//     );
//   }
// }

// Widget rowName(String name) {
//   return Padding(
//     padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
//     child: Text(
//       name,
//       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
//     ),
//   );
// }

// Widget rowValue(String value) {
//   return Padding(
//     padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
//     child: Text(
//       value,
//       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//     ),
//   );
// }
