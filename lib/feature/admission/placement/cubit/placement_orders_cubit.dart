import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/admission/placement/placement_repository/model/placement_order.dart';
import 'package:virok_wms/feature/admission/placement/placement_repository/placement_repository.dart';

part 'placement_orders_state.dart';

class PlacementOrdersCubit extends Cubit<PlacementOrderState> {
  PlacementOrdersCubit() : super(PlacementOrderState());

  Future<void> getOrders() async {
    try {
      final orders = await PlacementRepository()
          .getOrders('Admision_placement_documents_list', '');
      orders.errorMassage == 'OK'
          ? emit(
              state.copyWith(status: PlacementStatus.success, orders: orders))
          : emit(state.copyWith(
              status: PlacementStatus.notFound,
              errorMassage: orders.errorMassage));
    } catch (e) {
      emit(state.copyWith(status: PlacementStatus.failure, errorMassage: e.toString()));
    }
  }
}
