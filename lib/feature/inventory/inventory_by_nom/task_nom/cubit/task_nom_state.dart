part of 'task_nom_cubit.dart';

enum InventoryStatus { initial, loading, success, failure, notFound }

extension Inventorystatusx on InventoryStatus {
  bool get isInitial => this == InventoryStatus.initial;
  bool get isLoading => this == InventoryStatus.loading;
  bool get isSuccess => this == InventoryStatus.success;
  bool get isFailure => this == InventoryStatus.failure;
  bool get isNotFound => this == InventoryStatus.notFound;
}

final class InventoryByNomCellsTaskState extends Equatable {
  InventoryByNomCellsTaskState(
      {this.status = InventoryStatus.initial,
      this.errorMassage = '',
      this.time = 0,
      this.count = 0,
      this.nomBarcode = '',
      CellsByNom? noms})
      : cells = noms ?? CellsByNom.empty;
  final InventoryStatus status;
  final CellsByNom cells;
  final String errorMassage;
  final int time;
  final int count;
  final String nomBarcode;

  InventoryByNomCellsTaskState copyWith({
    InventoryStatus? status,
    CellsByNom? cells,
    String? errorMassage,
    int? time,
    int? count,
    String? nomBarcode 
  }) {
    return InventoryByNomCellsTaskState(
      status: status ?? this.status,
      noms: cells ?? this.cells,
      time: time ?? this.time,
      errorMassage: errorMassage ?? this.errorMassage,
      count: count ?? this.count,
      nomBarcode:nomBarcode ?? this.nomBarcode
    );
  }

  @override
  List<Object?> get props => [status, errorMassage, cells, time, count, nomBarcode];
}
