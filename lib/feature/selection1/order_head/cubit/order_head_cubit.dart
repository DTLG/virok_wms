import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/selection1/order_head/order_head_repository/order_head_repository.dart';
import 'package:virok_wms/models/orders.dart';


part 'order_head_state.dart';

class SelectionOrderHeadCubit extends Cubit<SelectionOrderHeadState> {
  SelectionOrderHeadCubit() : super(const SelectionOrderHeadState());

  Future<void> getOrders() async {
    try {
      emit(state.copyWith(status: SelectionOrderHeadStatus.loading));
      final orders = await SelectionOrderHeadRepository().getOrders('free_order','');
      emit(state.copyWith(status: SelectionOrderHeadStatus.success, orders: orders));
    } catch (e) {
      emit(state.copyWith(
        status: SelectionOrderHeadStatus.failure, errorMassage: e.toString()
      ));
    }
  }
}
