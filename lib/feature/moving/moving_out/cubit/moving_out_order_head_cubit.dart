import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/moving/moving_out/moving_out_client/moving_gate_api_client.dart';

import 'package:virok_wms/models/order.dart';

import '../moving_out_repository/moving_gate_order_head_repository.dart';

part 'moving_out_order_head_state.dart';

class MovingOutOrdersHeadCubit extends Cubit<MovingOutOrdersHeadState> {
  MovingOutOrdersHeadCubit() : super(const MovingOutOrdersHeadState());

  
  Future<void> getOrders() async {
    try {      await Future.delayed(const Duration(milliseconds: 500),(){});

      final orders =
          await MovingGateOrderHeadRepository().getOrders('get_moving_out_list', '');
      emit(state.copyWith(
          status: MovingOutOrdersHeadStatus.success, orders: orders));
    } catch (e) {
      emit(state.copyWith(
          status: MovingOutOrdersHeadStatus.failure,
          errorMassage: e.toString()));
    }
  }

  Future<bool> setBasketToOrder(String barcode, String docId) async {
    try {
      String bascketStatus =
          await MovingGateOrderDataClient().setBasketToOrder('$barcode $docId');

      bool res = false;
      if (bascketStatus == '0') {
        emit(state.copyWith(
            status: MovingOutOrdersHeadStatus.notFound,
            errorMassage: "Кошик зайнятий"));
        res = false;
      } else if (bascketStatus == '2') {
        emit(state.copyWith(
          status: MovingOutOrdersHeadStatus.notFound,
          errorMassage: "Кошик не знайдено",
        ));
        res = false;
      } else if (bascketStatus == '1') {
        emit(state.copyWith(buskeStatus: true));
        res = true;
      }
      emit(state.copyWith(
        status: MovingOutOrdersHeadStatus.success,
        errorMassage: "",
      ));
      return res;
    } catch (e) {
      emit(state.copyWith(status: MovingOutOrdersHeadStatus.failure));
      rethrow;
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
