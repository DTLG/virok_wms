import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/storage_operation/placement_writing_off/placement_writeing_off_repository/model/cell_model.dart';

import '../../placement_writeing_off_repository/placement_writeing_off_repository.dart';


part 'check_cell_state.dart';

class CheckCellCubit extends Cubit<CheckCellState> {
  CheckCellCubit() : super(const CheckCellState());

  Future<void> getCell(String barcode) async {
    try {
      emit(state.copyWith(status: CheckCellStatus.loading));
      final cell = await PlacementWritingOffRepo().getCeel(barcode);
      emit(state.copyWith(status: CheckCellStatus.success, cell: cell));
    } catch (e) {
      emit(state.copyWith(
          status: CheckCellStatus.failure, errorMassage: e.toString()));
    }
  }

  void clear() {
    emit(state.copyWith(
        errorMassage: '', cell: Cell.empty, status: CheckCellStatus.initial));
  }
}
