import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:virok_wms/models/order.dart';

import '../returning_out_client/returning_out_api_client.dart';
import '../returning_out_repository/returning_out_order_head_repository.dart';

part 'returning_out_order_head_state.dart';

class ReturningOutOrdersHeadCubit extends Cubit<ReturningOutOrdersHeadState> {
  ReturningOutOrdersHeadCubit() : super(const ReturningOutOrdersHeadState());

  Future<void> getOrders() async {
    try {
      await Future<void>.delayed(const Duration(seconds: 1));

      final orders = await ReturningOutOrderHeadRepository()
          .getOrders('get_return_out_list', '');
      emit(state.copyWith(
          status: ReturningOutOrdersHeadStatus.success, orders: orders));
    } catch (e) {
      emit(state.copyWith(
          status: ReturningOutOrdersHeadStatus.failure, errorMassage: e.toString()));
    }
  }

  Future<bool> setBasketToOrder(String barcode, String docId) async {
    try {
      String bascketStatus =
          await ReturningOutOrderDataClient().setBasketToOrder('$barcode $docId');

      bool res = false;
      if (bascketStatus == '0') {
        emit(state.copyWith(
            status: ReturningOutOrdersHeadStatus.notFound,
            errorMassage: "Кошик зайнятий"));
        res = false;
      } else if (bascketStatus == '2') {
        emit(state.copyWith(
          status: ReturningOutOrdersHeadStatus.notFound,
          errorMassage: "Кошик не знайдено",
        ));
        res = false;
      } else if (bascketStatus == '1') {
        emit(state.copyWith(buskeStatus: true));
        res = true;
      }
      emit(state.copyWith(
        status: ReturningOutOrdersHeadStatus.success,
        errorMassage: "",
      ));
      return res;
    } catch (e) {
      emit(state.copyWith(status: ReturningOutOrdersHeadStatus.failure));
      rethrow;
    }
  }

  void clear() {
    emit(state.copyWith(
        status: ReturningOutOrdersHeadStatus.initial,
        orders: Orders.empty,
        errorMassage: '',
        buskeStatus: false));
  }

// Future<void>getOrderBusket(String docId)async{
//   final basket = await MovingOrderHeadRepository().getOrderBaskets(docId);
//   print(basket);
// }
}
