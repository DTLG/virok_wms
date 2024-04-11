import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/inventory/inventory_by_nom/iventory_by_nom_repository/iventory_by_nom_repository.dart';
import 'package:virok_wms/feature/inventory/inventory_by_nom/models/barcode.dart';
import 'package:virok_wms/feature/inventory/inventory_by_nom/models/task.dart';

import '../../models/cells_by_nom.dart';

part 'task_nom_state.dart';

class InventoryByNomCellsTaskCubit extends Cubit<InventoryByNomCellsTaskState> {
  InventoryByNomCellsTaskCubit() : super(InventoryByNomCellsTaskState());

  Future<void> getCells(InventoryByNomTask task) async {
    try {
      String taskBarcode = '';

      if (task.barcodes.isNotEmpty) {
        taskBarcode = task.barcodes.first.barcode;
      }

      final cells = await IventoryByNomRepository().getCells(
          'Sku_Full_Inventory_all_status_data',
          '$taskBarcode ${task.docNumber}');
      if (cells.errorMassage == 'OK') {
        emit(state.copyWith(status: InventoryStatus.success, cells: cells));
      } else {
        emit(state.copyWith(
            errorMassage: cells.errorMassage,
            status: InventoryStatus.notFound,
            time: DateTime.now().millisecondsSinceEpoch));
      }
    } catch (e) {
      emit(state.copyWith(status: InventoryStatus.failure,errorMassage: e.toString()));
    }
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

  scanNom(String nomBarcode, List<Barcode> barcodes) {
    try {
      for (var barcode in barcodes) {
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

  Future<void> sendNom(String nomBarcode, int count, String docNumber,
      String nomStatus, String cellBarcode) async {
    try {
      final cells = await IventoryByNomRepository().getCells(
          'Sku_Full_Inventory_sku_scan',
          '$nomBarcode $count $docNumber $nomStatus $cellBarcode');
      if (cells.errorMassage == 'OK') {
        emit(state.copyWith(cells: cells, status: InventoryStatus.success));
      } else {
        emit(state.copyWith(
            errorMassage: cells.errorMassage,
            status: InventoryStatus.notFound,
            time: DateTime.now().millisecondsSinceEpoch));
      }
    } catch (e) {
      emit(state.copyWith(status: InventoryStatus.failure));
    }
  }

  Future<void> addNewCell(String nomBarcode, String docNumber, String nomStatus, String cellBarcode)async{
    try {
      final cells = await IventoryByNomRepository().getCells(
          'Add_row_to_Sku_Full_Inventory',
          '$nomBarcode $docNumber $nomStatus $cellBarcode');
      if (cells.errorMassage == 'OK') {
        emit(state.copyWith(cells: cells, status: InventoryStatus.success));
      } else {
        emit(state.copyWith(
            errorMassage: cells.errorMassage,
            status: InventoryStatus.notFound,
            time: DateTime.now().millisecondsSinceEpoch));
      }
    } catch (e) {
      emit(state.copyWith(status: InventoryStatus.failure));
    }
  }


}
