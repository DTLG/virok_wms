import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:virok_wms/ui/theme/theme.dart';

import '../../cubit/moving_out_order_data_cubit.dart';
import '../../cubit/moving_out_order_head_cubit.dart';

class AppBarButtonO extends StatelessWidget {
  const AppBarButtonO({super.key, required this.cubit, required this.docId});

  final MovingOutOrdersHeadCubit cubit;
  final String docId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: ElevatedButton(
        onPressed: () {
          final int checkFullScan =
              context.read<MovingOutOrderDataCubit>().checkFullOrder();
              

          if (checkFullScan == 0) {
            showDialog(
                context: context,
                builder: (_) => BlocProvider.value(
                      value: context.read<MovingOutOrderDataCubit>(),
                      child: CheckFullScanDialog(
                        cubit: cubit,
                        docId: docId,
                      ),
                    ));
          } else {
            context.read<MovingOutOrderDataCubit>().closeOrder(docId, cubit);
                  cubit.getOrders();

            Navigator.pop(context);
          }
        },
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(AppColors.darkBlue)),
        child: SizedBox(
            width: 75,
            child: Text(
              'Завершити',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall!.copyWith(color: Colors.white),
            )),
      ),
    );
  }
}

class CheckFullScanDialog extends StatelessWidget {
  const CheckFullScanDialog(
      {super.key, required this.cubit, required this.docId});

  final MovingOutOrdersHeadCubit cubit;
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
              context.read<MovingOutOrderDataCubit>().clear();
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
