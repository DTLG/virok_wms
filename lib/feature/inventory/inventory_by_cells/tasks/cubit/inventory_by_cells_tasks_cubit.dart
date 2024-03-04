import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/inventory/inventory_by_cells/iventory_by_cells_repository/iventory_by_cells_repository.dart';
import 'package:virok_wms/feature/inventory/inventory_by_cells/models/task.dart';

part 'inventory_by_cells_tasks_state.dart';

class InventoryByCellsTasksCubit extends Cubit<InventoryByCellsTasksState> {
  InventoryByCellsTasksCubit() : super(InventoryByCellsTasksState());

  Future<void> getTasks() async {
    try {
      final tasks = await IventoryByCellsRepository()
          .getTasks('Cell_Inventory_tasks_list', '');

      if (tasks.errorMassage == "OK") {
        emit(state.copyWith(
            status: InventoryCellsTaskStatus.success, tasks: tasks));
      } else {
        emit(state.copyWith(
            status: InventoryCellsTaskStatus.notFound,
            time: DateTime.now().millisecondsSinceEpoch,
            errorMassage: tasks.errorMassage));
      }
    } catch (e) {
      emit(state.copyWith(status: InventoryCellsTaskStatus.failure));
    }
  }

  Future<void> newTasks(String cell) async {
    try {
      final tasks = await IventoryByCellsRepository()
          .getTasks('Create_Cell_Inventory_task', cell);

      if (tasks.errorMassage == "OK") {
        emit(state.copyWith(
            status: InventoryCellsTaskStatus.success, tasks: tasks));
      } else {
        emit(state.copyWith(
            status: InventoryCellsTaskStatus.notFound,
            time: DateTime.now().millisecondsSinceEpoch,
            errorMassage: tasks.errorMassage));
      }
    } catch (e) {
      emit(state.copyWith(status: InventoryCellsTaskStatus.failure));
    }
  }

  InventoryByCellsTask searchTask(String barcode) {
    for (var task in state.tasks.inventoryTasks) {
      if (barcode == task.codeCell) {
        return task;
      }
    }
    emit(state.copyWith(
        status: InventoryCellsTaskStatus.notFound,
        time: DateTime.now().millisecondsSinceEpoch,
        errorMassage: 'Немає завданя за відсканованою коміркою'));
    return InventoryByCellsTask.empty;
  }

  Future<bool> closeTask(String taskNumber) async {
    try {
      final tasks = await IventoryByCellsRepository()
          .getTasks('Close_Cell_Inventory_task', taskNumber);

      if (tasks.errorMassage == "OK") {
        emit(state.copyWith(
            status: InventoryCellsTaskStatus.success, tasks: tasks));
        return true;
      } else {
        emit(state.copyWith(
            status: InventoryCellsTaskStatus.notFound,
            time: DateTime.now().millisecondsSinceEpoch,
            errorMassage: tasks.errorMassage));
        return false;
      }
    } catch (e) {
      emit(state.copyWith(status: InventoryCellsTaskStatus.failure));
      return false;
    }
  }
}
