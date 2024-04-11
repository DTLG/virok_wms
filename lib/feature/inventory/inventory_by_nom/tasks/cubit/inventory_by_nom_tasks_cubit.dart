import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/inventory/inventory_by_nom/iventory_by_nom_repository/iventory_by_nom_repository.dart';
import 'package:virok_wms/feature/inventory/inventory_by_nom/models/task.dart';

part 'inventory_by_nom_tasks_state.dart';

class InventoryByNomTasksCubit extends Cubit<InventoryByNomTasksState> {
  InventoryByNomTasksCubit() : super(InventoryByNomTasksState());

  Future<void> getTasks() async {
    try {
      final tasks = await IventoryByNomRepository()
          .getTasks('Sku_Full_Inventory_docs_list', '');

      if (tasks.errorMassage == "OK") {
        emit(state.copyWith(status: InventoryStatus.success, tasks: tasks));
      } else {
        emit(state.copyWith(
            status: InventoryStatus.notFound,
            time: DateTime.now().millisecondsSinceEpoch,
            errorMassage: tasks.errorMassage));
      }
    } catch (e) {
      emit(state.copyWith(status: InventoryStatus.failure,errorMassage: e.toString()));
    }
  }

  InventoryByNomTask searchTask(String barcode) {
    for (var task in state.tasks.tasks) {
      for (var bar in task.barcodes) {
        if (barcode == bar.barcode) {
          return task;
        }
      }
    }
    emit(state.copyWith(
        status: InventoryStatus.notFound,
        time: DateTime.now().millisecondsSinceEpoch,
        errorMassage: 'Немає завданя за відсканованою коміркою'));
    return InventoryByNomTask.empty;
  }

  Future<bool> closeTask(String taskNumber) async {
    try {
      final tasks = await IventoryByNomRepository()
          .getTasks('Close_Sku_Full_Inventory ', taskNumber);

      if (tasks.errorMassage == "OK") {
        emit(state.copyWith(
            status: InventoryStatus.success, tasks: tasks));
        return true;
      } else {
        emit(state.copyWith(
            status: InventoryStatus.notFound,
            time: DateTime.now().millisecondsSinceEpoch,
            errorMassage: tasks.errorMassage));
        return false;
      }
    } catch (e) {
      emit(state.copyWith(status: InventoryStatus.failure));
      return false;
    }
  }
}
