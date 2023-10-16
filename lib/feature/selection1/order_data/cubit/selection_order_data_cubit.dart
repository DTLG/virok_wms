import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/selection1/order_data/selection_order_data_repository/selection_order_data_repository.dart';
import 'package:virok_wms/models/noms_model.dart';

part 'selection_order_data_state.dart';

class SelectionOrderDataCubit extends Cubit<SelectionOrderDataState> {
  SelectionOrderDataCubit() : super(SelectionOrderDataState());

  Future<void> getOrder(String docId) async {
    try {
      emit(state.copyWith(status: SelectionOrderDataStatus.loading));
      final orders = await SelectionOrderDataRepository()
          .selectionRepo('selection', docId);
      emit(state.copyWith(
          status: SelectionOrderDataStatus.success, noms: orders));
    } catch (e) {
      emit(state.copyWith(
          status: SelectionOrderDataStatus.failure,
          errorMassage: e.toString()));
    }
  }

  Future<void> updateStatus(String docId) async {
    try {
      emit(state.copyWith(status: SelectionOrderDataStatus.loading));
      final orders = await SelectionOrderDataRepository().updateStatus(docId);
      emit(state.copyWith(status: SelectionOrderDataStatus.success,orderStatus: orders['status']));
      print(orders['status']);
    } catch (e) {
      emit(state.copyWith(
          status: SelectionOrderDataStatus.failure,
          errorMassage: e.toString()));
    }
  }
}
