import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/inventory/inventory_by_cells/iventory_by_cells_repository/iventory_by_cells_repository.dart';
import 'package:virok_wms/feature/inventory/inventory_by_cells/models/task_noms.dart';

part 'task_noms_state.dart';

class InventoryByCellsTaskNomsCubit
    extends Cubit<InventoryByCellsTaskNomsState> {
  InventoryByCellsTaskNomsCubit() : super(InventoryByCellsTaskNomsState());

  Future<void> getNoms(String taskNumber) async {
    try {
      final noms = await IventoryByCellsRepository()
          .getNoms('Cell_Inventory_task_data', taskNumber);
      if (noms.errorMassage == 'OK') {
        emit(state.copyWith(status: InventoryStatus.success, noms: noms));
      } else {
        emit(state.copyWith(
            errorMassage: noms.errorMassage,
            status: InventoryStatus.notFound,
            time: DateTime.now().millisecondsSinceEpoch));
      }
    } catch (e) {
      emit(state.copyWith(status: InventoryStatus.failure));
    }
  }

  CellInventoryTaskNom searchNom(String barcode) {
    for (var nom in state.noms.cellInventoryTaskData) {
      for (var bar in nom.barcodes) {
        if (barcode == bar.barcode) {
          return nom;
        }
      }
    }
    emit(state.copyWith(
        errorMassage: 'Товар не знайдено, або штрихкод не належить товару',
        status: InventoryStatus.notFound,
        time: DateTime.now().millisecondsSinceEpoch));
    return CellInventoryTaskNom.empty;
  }

  bool scanCell(String cellBarcode, String cell) {
    try {
      if (cell != cellBarcode) {
        emit(state.copyWith(
            status: InventoryStatus.notFound,
            time: DateTime.now().millisecondsSinceEpoch,
            errorMassage: 'Відскановано не ту комірку'));
        return false;
      }
      return true;
    } catch (e) {
      emit(state.copyWith(status: InventoryStatus.failure));
      rethrow;
    }
  }

  scanNom(String nomBarcode, CellInventoryTaskNom nom) {
    try {
      for (var barcode in nom.barcodes) {
        if (barcode.barcode == nomBarcode) {
          emit(state.copyWith(
            nomBarcode: nomBarcode,
            count: state.count + barcode.ratio,
            status: InventoryStatus.success,
          ));
          return;
        }
      }
      emit(state.copyWith(
          status: InventoryStatus.notFound,
          time: DateTime.now().millisecondsSinceEpoch,
          errorMassage: 'Відскановано не той товар'));
    } catch (e) {
      emit(state.copyWith(status: InventoryStatus.failure));
    }
  }

  void manualCountIncrement(String count) {
    emit(state.copyWith(
      count: int.parse(count),
      status: InventoryStatus.success,
    ));
  }

  void clear() {
    emit(state.copyWith(
        count: 0,
        errorMassage: '',
        nomBarcode: '',
        status: InventoryStatus.success));
  }

  Future<void> sendNom(String nomBarcode, String count, String docNumber,
      String nomStatus, String cellBarcode) async {
    try {
      final noms = await IventoryByCellsRepository().getNoms(
          'Cell_Inventory_sku_task_scan',
          '$nomBarcode $count $docNumber $nomStatus $cellBarcode');
      if (noms.errorMassage == 'OK') {
        emit(state.copyWith(noms: noms, status: InventoryStatus.success));
      } else {
        emit(state.copyWith(
            errorMassage: noms.errorMassage,
            status: InventoryStatus.notFound,
            time: DateTime.now().millisecondsSinceEpoch));
      }
    } catch (e) {
      emit(state.copyWith(status: InventoryStatus.failure));
    }
  }
}
