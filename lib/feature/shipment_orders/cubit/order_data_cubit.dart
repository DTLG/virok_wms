import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/models/noms_model.dart';

import '../shipment_orders_repository/shipment_orders_repository.dart';

part 'order_data_state.dart';

class ShipmentDataCubit extends Cubit<ShipmentDataState> {
  ShipmentDataCubit() : super(const ShipmentDataState());

  Future<void> getOrder(String docId) async {
    try {
      final noms = await ShipmentRepository().getOrder(docId);
      emit(state.copyWith(status: ShipmentStatus.success, noms: noms));
    } catch (e) {
      emit(state.copyWith(
        status: ShipmentStatus.failure,
      ));
    }
  }
}
