
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/selection/cubit/selection_order_head_cubit.dart';
import 'package:virok_wms/feature/selection/cubit/selection_order_data_cubit.dart';
import 'package:virok_wms/ui/theme/theme.dart';

class AppBarButton extends StatelessWidget {
  const AppBarButton({super.key, required this.cubit});

  final SelectionOrdersHeadCubit cubit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: ElevatedButton(
        onPressed: () {
          if (context.read<SelectionOrderDataCubit>().state.itsMezonine == true) {
            context.read<SelectionOrderDataCubit>().closeOrder();
            cubit.getOrders();
            Navigator.pop(context);
          } else {
            context.read<SelectionOrderDataCubit>().closeOrder();
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

extension on int {
  String get toText {
    switch (this) {
      case 0:
        return 'Розпочати роботу';
      case 1:
        return 'В роботі';
      case 2:
        return 'Закрити кошик';
      default:
        return '';
    }
  }

  Color get toColor {
    switch (this) {
      case 0:
        return Colors.grey;
      case 1:
        return Colors.green;
      case 2:
        return const Color(0xFF154895);
      default:
        return Colors.grey;
    }
  }
}
