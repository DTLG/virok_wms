import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../returning_in_repository/returning_in_head_repository.dart';
import '../returning_in_repository/models/order.dart';

part 'returning_in_head_state.dart';

class ReturningInHeadCubit extends Cubit<ReturningInHeadState> {
  ReturningInHeadCubit() : super(const ReturningInHeadState());

  Future<void> getOrders() async {
    try {
          await Future<void>.delayed(const Duration(microseconds: 1));

      emit(state.copyWith(status: ReturningInHeadStatus.loading));
                await Future<void>.delayed(const Duration(seconds: 1));



      final orders = await ReturningInHeadRepository()
          .getOrders('get_return_in_list', '');
      emit(state.copyWith(
          status: ReturningInHeadStatus.success, orders: orders));
    } catch (e) {
      emit(state.copyWith(
          status: ReturningInHeadStatus.failure,
          errorMassage: e.toString()));
    }
  }


  void clear() {
    emit(state.copyWith(
        status: ReturningInHeadStatus.initial,
        orders: ReturningInOrders.empty,
        errorMassage: '',
        buskeStatus: false));
  }

   

   
}
