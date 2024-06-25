part of 'inventory_nom_in_cell_cubit.dart';

enum InventoryStatus { initial, loading, success, failure, notFound }

extension Inventorystatusx on InventoryStatus {
  bool get isInitial => this == InventoryStatus.initial;
  bool get isLoading => this == InventoryStatus.loading;
  bool get isSuccess => this == InventoryStatus.success;
  bool get isFailure => this == InventoryStatus.failure;
  bool get isNotFound => this == InventoryStatus.notFound;
}

final class InventoryNomInCellState extends Equatable {
  InventoryNomInCellState(
      {this.status = InventoryStatus.initial,
      this.errorMassage = '',
      this.time = 0,
      this.count = 0,
      this.nomBarcode = '',
      InventoryNomInCellTasks? tasks})
      : tasks = tasks ?? InventoryNomInCellTasks.empty;
  final InventoryStatus status;
  final InventoryNomInCellTasks tasks;
  final String errorMassage;
  final int time;
  final int count;
  final String nomBarcode;

  InventoryNomInCellState copyWith(
      {InventoryStatus? status,
      InventoryNomInCellTasks? tasks,
      String? errorMassage,
      int? time,
      int? count,
      String? nomBarcode}) {
    return InventoryNomInCellState(
        status: status ?? this.status,
        tasks: tasks ?? this.tasks,
        errorMassage: errorMassage ?? this.errorMassage,
        time: time ?? this.time,
        count: count ?? this.count,
        nomBarcode: nomBarcode ?? this.nomBarcode);
  }

  @override
  List<Object?> get props => [status, errorMassage, tasks, time, nomBarcode, count];
}
