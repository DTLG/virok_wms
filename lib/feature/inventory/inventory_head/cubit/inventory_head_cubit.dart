import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/inventory/inventory_data_repository/inventory_repository.dart';
import 'package:virok_wms/feature/inventory/models/doc.dart';

part 'inventory_head_state.dart';

class InventoryHeadCubit extends Cubit<InventoryHeadState> {
  InventoryHeadCubit() : super(InventoryHeadState());

  Future<void> getDocs() async {
    try {
      final docs = await InventoryRepository().getDocs();
      emit(state.copyWith(docs: docs, status: InventoryStatus.success));
    } catch (e) {
      emit(state.copyWith(status: InventoryStatus.failure));
    }
  }
}
