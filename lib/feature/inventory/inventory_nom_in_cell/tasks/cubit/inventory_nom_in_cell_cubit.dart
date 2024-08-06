import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/inventory/inventory_nom_in_cell/inventory_nom_in_cell_repo/inventory_nom_in_cell_repo.dart';

import '../../models/models.dart';

part 'inventory_nom_in_cell_state.dart';

class InventoryNomInCellCubit extends Cubit<InventoryNomInCellState> {
  InventoryNomInCellCubit() : super(InventoryNomInCellState());

  Future<void> getTasks() async {
    try {
      final tasks = await InventoryNomInCellRepository()
          .getTasks('Inventory_tasks_list', '');

      if (tasks.errorMassage == "OK") {
        emit(state.copyWith(status: InventoryStatus.success, tasks: tasks));
      } else {
        emit(state.copyWith(
            status: InventoryStatus.notFound,
            time: DateTime.now().millisecondsSinceEpoch,
            errorMassage: tasks.errorMassage));
      }
    } catch (e) {
      emit(state.copyWith(status: InventoryStatus.failure));
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
      count: double.parse(count),
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

  Future<void> sendNom(String nomBarcode, double count, String docNumber,
      String cellBarcode) async {
    try {
      final tasks = await InventoryNomInCellRepository().getTasks(
          'Inventory_sku_task_scan',
          '$nomBarcode $count $docNumber $cellBarcode');
      if (tasks.errorMassage == 'OK') {
        emit(state.copyWith(tasks: tasks, status: InventoryStatus.success));
      } else {
        emit(state.copyWith(
            errorMassage: tasks.errorMassage,
            status: InventoryStatus.notFound,
            time: DateTime.now().millisecondsSinceEpoch));
      }
    } catch (e) {
      emit(state.copyWith(status: InventoryStatus.failure));
    }
  }

  Future<void> createNewTask(
      String nomBar, String nomStatus, String cellBarcode) async {
    try {
      final tasks = await InventoryNomInCellRepository().getTasks(
          'Create_Inventory_sku_task', '$nomBar $nomStatus $cellBarcode');

      if (tasks.errorMassage == "OK") {
        emit(state.copyWith(status: InventoryStatus.success, tasks: tasks));
      } else {
        emit(state.copyWith(
            status: InventoryStatus.notFound,
            time: DateTime.now().millisecondsSinceEpoch,
            errorMassage: tasks.errorMassage));
      }
    } catch (e) {
      emit(state.copyWith(status: InventoryStatus.failure));
    }
  }

  Future<void> closeTask(String taskNumber) async {
    try {
      final tasks = await InventoryNomInCellRepository()
          .getTasks('Close_Inventory_sku_task', taskNumber);

      if (tasks.errorMassage == "OK") {
        emit(state.copyWith(status: InventoryStatus.success, tasks: tasks));
      } else {
        emit(state.copyWith(
            status: InventoryStatus.notFound,
            time: DateTime.now().millisecondsSinceEpoch,
            errorMassage: tasks.errorMassage));
      }
    } catch (e) {
      emit(state.copyWith(status: InventoryStatus.failure));
    }
  }
}





// Inventory_sku_task_scan