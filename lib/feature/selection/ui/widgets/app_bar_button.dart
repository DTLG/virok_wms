import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/selection/cubit/selection_order_head_cubit.dart';
import 'package:virok_wms/feature/selection/cubit/selection_order_data_cubit.dart';
import 'package:virok_wms/ui/theme/theme.dart';

// class AppBarButton extends StatelessWidget {
//   const AppBarButton({super.key, required this.cubit, required this.docId});

//   final SelectionOrdersHeadCubit cubit;
//   final String docId;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Padding(
//       padding: const EdgeInsets.all(7.0),
//       child: ElevatedButton(
//         onPressed: () {
//           final int checkFullScan =
//               context.read<SelectionOrderDataCubit>().checkFullOrder();
              

//           if (checkFullScan == 0) {
//             showDialog(
//                 context: context,
//                 builder: (_) => BlocProvider.value(
//                       value: context.read<SelectionOrderDataCubit>(),
//                       child: CheckFullScanDialog(
//                         cubit: cubit,
//                         docId: docId,
//                       ),
//                     ));
//           } else {
//             context.read<SelectionOrderDataCubit>().closeOrder(docId, cubit);
//                   cubit.getOrders();

//             Navigator.pop(context);
//           }
//         },
//         style: const ButtonStyle(
//             backgroundColor: MaterialStatePropertyAll(AppColors.darkBlue)),
//         child: SizedBox(
//             width: 75,
//             child: Text(
//               'Завершити',
//               textAlign: TextAlign.center,
//               style: theme.textTheme.titleSmall!.copyWith(color: Colors.white),
//             )),
//       ),
//     );
//   }
// }

class CheckFullScanDialog extends StatelessWidget {
  const CheckFullScanDialog(
      {super.key, required this.cubit, required this.docId});

  final SelectionOrdersHeadCubit cubit;
  final String docId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      iconPadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      icon: Align(
        alignment: Alignment.centerRight,
        child: IconButton(
            onPressed: () {
              context.read<SelectionOrderDataCubit>().clear();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close)),
      ),
      content: const Text(
        'Накладна відсканована не повністю',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.all(5),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Продовжити'))
      ],
    );
  }
}
