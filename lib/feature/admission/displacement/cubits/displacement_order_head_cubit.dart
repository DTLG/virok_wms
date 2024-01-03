import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../displacement_repository/displacement_order_head_repository.dart';
import '../displacement_repository/models/order.dart';

part 'displacement_order_head_state.dart';

class DisplacementOrdersHeadCubit extends Cubit<DisplacementOrdersHeadState> {
  DisplacementOrdersHeadCubit() : super(const DisplacementOrdersHeadState());

  Future<void> getOrders() async {
    try {
      await Future<void>.delayed(const Duration(seconds: 1));

      final orders = await DiplacementOrderHeadRepository()
          .getOrders('IncomingInvoice_list', '');
      emit(state.copyWith(
          status: DisplacementOrdersHeadStatus.success, orders: orders));
    } catch (e) {
      emit(state.copyWith(
          status: DisplacementOrdersHeadStatus.failure,
          errorMassage: e.toString()));
    }
  }

  void clear() {
    emit(state.copyWith(
        status: DisplacementOrdersHeadStatus.initial,
        orders: DisplacementOrders.empty,
        errorMassage: '',
        buskeStatus: false));
  }
}
