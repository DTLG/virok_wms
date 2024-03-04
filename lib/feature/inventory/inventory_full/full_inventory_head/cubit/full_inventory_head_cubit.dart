import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/inventory/inventory_full/full_inventory_data_repository/full_inventory_repository.dart';
import 'package:virok_wms/feature/inventory/inventory_full/models/doc.dart';


part 'full_inventory_head_state.dart';

class FullInventoryHeadCubit extends Cubit<FullInventoryHeadState> {
  FullInventoryHeadCubit() : super(FullInventoryHeadState());

  Future<void> getDocs() async {
    try {
      final docs = await FullInventoryRepository().getDocs();
      emit(state.copyWith(docs: docs, status: FullInventoryHeadStatus.success));
    } catch (e) {
      emit(state.copyWith(status: FullInventoryHeadStatus.failure));
    }
  }
}
