import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/selection/selection_repository/selection_order_head_repository.dart';
import 'package:virok_wms/models/order.dart';

import '../selection_client/selection_api_client.dart';

part 'selection_order_head_state.dart';

class SelectionOrdersHeadCubit extends Cubit<SelectioOrdersHeadState> {
  SelectionOrdersHeadCubit() : super(const SelectioOrdersHeadState());

  Future<void> getOrders() async {
    try {
      final orders =
          await SelectionOrderHeadRepository().getOrders('get_orders_list', '');
      emit(state.copyWith(
        status: SelectioOrdersHeadStatus.success,
        orders: orders,
        oldOrdersCount: orders.orders.length,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: SelectioOrdersHeadStatus.failure,
          errorMassage: e.toString()));
    }
  }

  Future<bool> getUpdatedOrders() async {
    try {
      final newOrders =
          await SelectionOrderHeadRepository().getOrders('get_orders_list', '');
      final previousOrders = state.orders;

      emit(state.copyWith(
        status: SelectioOrdersHeadStatus.success,
        orders: newOrders,
        oldOrdersCount: newOrders.orders.length,
      ));

      final uniqueNewOrders = newOrders.orders.where((newOrder) {
        return !previousOrders.orders
            .any((oldOrder) => oldOrder.docId == newOrder.docId);
      }).toList();

      if (uniqueNewOrders.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      emit(state.copyWith(
        status: SelectioOrdersHeadStatus.failure,
        errorMassage: e.toString(),
      ));
      return false;
    }
  }

  Future<bool> setBasketToOrder(String barcode, String docId) async {
    try {
      String bascketStatus =
          await SelectionOrderDataClient().setBasketToOrder('$barcode $docId');

      bool res = false;
      if (bascketStatus == '0') {
        emit(state.copyWith(
            status: SelectioOrdersHeadStatus.notFound,
            errorMassage: "Кошик зайнятий",
            time: DateTime.now().millisecondsSinceEpoch));
        false;
      }
      if (bascketStatus == '2') {
        emit(state.copyWith(
            status: SelectioOrdersHeadStatus.notFound,
            errorMassage: "Кошик не знайдено",
            time: DateTime.now().millisecondsSinceEpoch));
        res = false;
      } else if (bascketStatus == '1') {
        emit(state.copyWith(
            buskeStatus: true, status: SelectioOrdersHeadStatus.success));
        res = true;
      }

      return res;
    } catch (e) {
      emit(state.copyWith(status: SelectioOrdersHeadStatus.failure));
      rethrow;
    }
  }

  void clear() {
    emit(state.copyWith(
        status: SelectioOrdersHeadStatus.initial,
        orders: Orders.empty,
        errorMassage: '',
        buskeStatus: false));
  }

  int get oldOrdersCount => state.oldOrdersCount;

  void setOldOrdersCount(int value) {
    emit(state.copyWith(oldOrdersCount: value));
  }
}
