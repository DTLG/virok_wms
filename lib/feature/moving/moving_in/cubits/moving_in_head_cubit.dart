import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../moving_in_repository/moving_in_head_repository.dart';
import '../moving_in_repository/models/order.dart';

part 'moving_in_head_state.dart';

class MovingInHeadCubit extends Cubit<MovingInHeadState> {
  MovingInHeadCubit() : super(const MovingInHeadState());

  Future<void> getOrders() async {
    try {
          await Future<void>.delayed(const Duration(microseconds: 1));

      emit(state.copyWith(status: MovingInHeadStatus.loading));
                await Future<void>.delayed(const Duration(seconds: 1));



      final orders = await MovingInHeadRepository()
          .getOrders('get_moving_in_list', '');
      emit(state.copyWith(
          status: MovingInHeadStatus.success, orders: orders));
    } catch (e) {
      emit(state.copyWith(
          status: MovingInHeadStatus.failure,
          errorMassage: e.toString()));
    }
  }


  void clear() {
    emit(state.copyWith(
        status: MovingInHeadStatus.initial,
        orders: MovingInOrders.empty,
        errorMassage: '',
        buskeStatus: false));
  }

   

   
}
