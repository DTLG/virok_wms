import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/return/return_repository/models/order.dart';
import 'package:virok_wms/feature/return/return_repository/return_head_repository.dart';


part 'return_head_state.dart';

class ReturnHeadCubit extends Cubit<ReturnHeadState> {
  ReturnHeadCubit() : super(const ReturnHeadState());

  Future<void> getOrders() async {
    try {
          await Future<void>.delayed(const Duration(microseconds: 1));

      emit(state.copyWith(status: ReturnHeadStatus.loading));
                await Future<void>.delayed(const Duration(seconds: 1));



      final orders = await ReturnHeadRepository()
          .getOrders('get_return_in_list', '');
      emit(state.copyWith(
          status: ReturnHeadStatus.success, orders: orders));
    } catch (e) {
      emit(state.copyWith(
          status: ReturnHeadStatus.failure,
          errorMassage: e.toString()));
    }
  }


  void clear() {
    emit(state.copyWith(
        status: ReturnHeadStatus.initial,
        orders: ReturnOrders.empty,
        errorMassage: '',
        buskeStatus: false));
  }

   

   
}
