import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:virok_wms/models/order.dart';

import '../moving_out_repository/moving_out_order_head_repository.dart';

part 'moving_gate_order_head_state.dart';

class MovingGateOrdersHeadCubit extends Cubit<MovingGateOrdersHeadState> {
  MovingGateOrdersHeadCubit() : super(const MovingGateOrdersHeadState());

  Future<void> getOrders() async {
    try {
      await Future<void>.delayed(const Duration(seconds: 1));

      final orders = await MovingOutOrderHeadRepository()
          .getMovingList('get_moving_out_fromIncoming_list', '');
      emit(state.copyWith(
          status: MovingOutOrdersHeadStatus.success, orders: orders));
    } catch (e) {
      emit(state.copyWith(
          status: MovingOutOrdersHeadStatus.failure, errorMassage: e.toString()));
    }
  }



  void clear() {
    emit(state.copyWith(
        status: MovingOutOrdersHeadStatus.initial,
        orders: Orders.empty,
        errorMassage: '',
        buskeStatus: false));
  }


}
