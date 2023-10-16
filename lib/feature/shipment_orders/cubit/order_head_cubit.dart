import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/shipment_orders/shipment_orders_repository/models/orders.dart';
import 'package:virok_wms/feature/shipment_orders/shipment_orders_repository/shipment_orders_repository.dart';

part 'order_head_state.dart';

class ShipmentHeadCubit extends Cubit<ShipmentHeadState> {
  ShipmentHeadCubit() : super(const ShipmentHeadState());

  Future<void> getOrders() async {
    try {
      final orders = await ShipmentRepository().getOrders();
      emit(state.copyWith(status: ShipmentStatus.success, orders: orders));
    } catch (e) {
      emit(state.copyWith(
        status: ShipmentStatus.failure,
      ));
    }
  }
}
