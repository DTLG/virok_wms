import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/placement_writing_off/placement_writeing_off_repository/model/cell_model.dart';
import 'package:virok_wms/feature/placement_writing_off/placement_writeing_off_repository/placement_writeing_off_repository.dart';

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
}
