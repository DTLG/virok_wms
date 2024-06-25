part of 'inventory_by_nom_tasks_cubit.dart';

enum InventoryStatus { initial, loading, success, failure, notFound }

extension Inventorystatusx on InventoryStatus {
  bool get isInitial => this == InventoryStatus.initial;
  bool get isLoading => this == InventoryStatus.loading;
  bool get isSuccess => this == InventoryStatus.success;
  bool get isFailure => this == InventoryStatus.failure;
  bool get isNotFound => this == InventoryStatus.notFound;
}

final class InventoryByNomTasksState extends Equatable {
  InventoryByNomTasksState(
      {this.status = InventoryStatus.initial,
      this.errorMassage = '',
      this.time = 0,
      InventoryByNomTasks? tasks})
      : tasks = tasks ?? InventoryByNomTasks.empty;
  final InventoryStatus status;
  final InventoryByNomTasks tasks;
  final String errorMassage;
  final int time;

  InventoryByNomTasksState copyWith({
    InventoryStatus? status,
    InventoryByNomTasks? tasks,
    String? errorMassage,
    int? time
  }) {
    return InventoryByNomTasksState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      errorMassage: errorMassage ?? this.errorMassage,
      time: time ?? this.time
    );
  }

  @override
  List<Object?> get props => [status, errorMassage, tasks, time];
}
