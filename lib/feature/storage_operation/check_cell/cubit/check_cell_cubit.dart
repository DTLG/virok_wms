import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/storage_operation/check_cell/check_cell_repository/check_cell_repository.dart';
import 'package:virok_wms/models/check_cell.dart';
import 'package:virok_wms/feature/storage_operation/check_nom/models/barcodes_noms.dart' as chackNom;

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

  Future<List<chackNom.Cell>> getNoms(String value) async {
    try {
      final noms =
          await CheckCellRepository().getNoms('get_from_article', value);

      return noms.noms.first.cells;
    } catch (e) {
      emit(state.copyWith(
          status: CheckCellStatus.failure, errorMassage: e.toString()));
      return [];
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
