import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virok_wms/feature/selection1/order_data/cubit/selection_order_data_cubit.dart';

class AppBarButton extends StatefulWidget {
  const AppBarButton({super.key});

  @override
  State<AppBarButton> createState() => _AppBarButtonState();
}

class _AppBarButtonState extends State<AppBarButton> {
  @override
  Widget build(BuildContext context) {
    final int status =
        context.read<SelectionOrderDataCubit>().state.orderStatus;

    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: ElevatedButton(
        onPressed: () {
          if (status == 0) {
            context.read<SelectionOrderDataCubit>().updateStatus('docId');
          } else if (status == 1) {
                        context.read<SelectionOrderDataCubit>().updateStatus('docId');

            Navigator.pop(context);
          }
          // status = status == 0 ? 1 : 2;

          setState(() {});
        },
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(status.toColor)),
        child: SizedBox(
            width: 80,
            child: Text(
              status.toText,
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
