import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/storage_operation/check_cell/check_cell_repository/check_cell_repository.dart';
import 'package:virok_wms/feature/storage_operation/check_cell/check_cell_repository/model/check_cell_model.dart';

part 'check_cell_state.dart';

class CheckCellCubit extends Cubit<CheckCellState> {
  CheckCellCubit() : super(CheckCellState());

  Future<void> getCell(String barcode) async {
    try {

      final cell =
          await CheckCellRepository().getCellData('cell_data', barcode);
      if (cell.errorMasssage == 'OK') {
        emit(state.copyWith(status: CheckCellStatus.success, cell: cell));
      } else {
        emit(state.copyWith(
            status: CheckCellStatus.notFound,
            cell: cell,
            errorMassage: cell.errorMasssage));
      }
    } catch (e) {
      emit(state.copyWith(
          status: CheckCellStatus.failure, errorMassage: e.toString()));
    }
  }

  Future<void> setMinRest(
    String cellBarcode,
    String count,
    String nomBarcode,
  ) async {
    try {
      final cell = await CheckCellRepository()
          .getCellData('set_min_rest', '$nomBarcode $count $cellBarcode');

      if (cell.errorMasssage == 'OK') {
        emit(state.copyWith(status: CheckCellStatus.success, cell: cell));
      } else {
        emit(state.copyWith(
            status: CheckCellStatus.notFound,
            cell: cell,
            errorMassage: cell.errorMasssage));
      }
    } catch (e) {
      emit(state.copyWith(
          status: CheckCellStatus.failure, errorMassage: e.toString()));
    }
  }

  void clear() {
    emit(state.copyWith(
        errorMassage: '',
        cell: CheckCell.empty,
        time: 0,
        status: CheckCellStatus.initial));
  }
}
