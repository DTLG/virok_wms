part of 'inventory_by_cells_tasks_cubit.dart';

enum InventoryCellsTaskStatus { initial, loading, success, failure, notFound }

extension Inventorystatusx on InventoryCellsTaskStatus {
  bool get isInitial => this == InventoryCellsTaskStatus.initial;
  bool get isLoading => this == InventoryCellsTaskStatus.loading;
  bool get isSuccess => this == InventoryCellsTaskStatus.success;
  bool get isFailure => this == InventoryCellsTaskStatus.failure;
  bool get isNotFound => this == InventoryCellsTaskStatus.notFound;
}

final class InventoryByCellsTasksState extends Equatable {
  InventoryByCellsTasksState(
      {this.status = InventoryCellsTaskStatus.initial,
      this.errorMassage = '',
      this.time = 0,
      InventoryByCellsTasks? tasks})
      : tasks = tasks ?? InventoryByCellsTasks.empty;
  final InventoryCellsTaskStatus status;
  final InventoryByCellsTasks tasks;
  final String errorMassage;
  final int time;

  InventoryByCellsTasksState copyWith({
    InventoryCellsTaskStatus? status,
    InventoryByCellsTasks? tasks,
    String? errorMassage,
    int? time
  }) {
    return InventoryByCellsTasksState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      errorMassage: errorMassage ?? this.errorMassage,
      time: time ?? this.time
    );
  }

  @override
  List<Object?> get props => [status, errorMassage, tasks, time];
}
