part of 'task_noms_cubit.dart';

enum InventoryStatus { initial, loading, success, failure, notFound }

extension Inventorystatusx on InventoryStatus {
  bool get isInitial => this == InventoryStatus.initial;
  bool get isLoading => this == InventoryStatus.loading;
  bool get isSuccess => this == InventoryStatus.success;
  bool get isFailure => this == InventoryStatus.failure;
  bool get isNotFound => this == InventoryStatus.notFound;
}

final class InventoryByCellsTaskNomsState extends Equatable {
  InventoryByCellsTaskNomsState(
      {this.status = InventoryStatus.initial,
      this.errorMassage = '',
      this.time = 0,
      this.count = 0,
      this.nomBarcode = '',
      CellInventoryTaskNoms? noms})
      : noms = noms ?? CellInventoryTaskNoms.empty;
  final InventoryStatus status;
  final CellInventoryTaskNoms noms;
  final String errorMassage;
  final int time;
  final int count;
  final String nomBarcode;

  InventoryByCellsTaskNomsState copyWith({
    InventoryStatus? status,
    CellInventoryTaskNoms? noms,
    String? errorMassage,
    int? time,
    int? count,
    String? nomBarcode 
  }) {
    return InventoryByCellsTaskNomsState(
      status: status ?? this.status,
      noms: noms ?? this.noms,
      time: time ?? this.time,
      errorMassage: errorMassage ?? this.errorMassage,
      count: count ?? this.count,
      nomBarcode:nomBarcode ?? this.nomBarcode
    );
  }

  @override
  List<Object?> get props => [status, errorMassage, noms, time, count, nomBarcode];
}
