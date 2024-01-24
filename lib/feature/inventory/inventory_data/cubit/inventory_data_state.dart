part of 'inventory_data_cubit.dart';

enum InventoryStatus { initial, loading, success, failure, notFound }

extension Inventorystatusx on InventoryStatus {
  bool get isInitial => this == InventoryStatus.initial;
  bool get isLoading => this == InventoryStatus.loading;
  bool get isSuccess => this == InventoryStatus.success;
  bool get isFailure => this == InventoryStatus.failure;
  bool get isNotFound => this == InventoryStatus.notFound;
}

final class InventoryDataState extends Equatable {
  InventoryDataState({
    this.status = InventoryStatus.initial,
    this.time = 0,
    this.nomBarcode = '',
    this.count = 0,
    Inventory? nom,
    this.errorMassage = '',
  }) : nom = nom ?? Inventory.empty;

  final InventoryStatus status;
  final Inventory nom;
  final int time;
  final int count;
  final String nomBarcode;
  final String errorMassage;

  InventoryDataState copyWith(
      {InventoryStatus? status,
      int? time,
      Inventory? nom,
      String? errorMassage,
      String? nomBarcode,
      int? count}) {
    return InventoryDataState(
        status: status ?? this.status,
        nom: nom ?? this.nom,
        errorMassage: errorMassage ?? this.errorMassage,
        time: time ?? this.time,
        count: count ?? this.count,
        nomBarcode: nomBarcode ?? this.nomBarcode);
  }

  @override
  List<Object?> get props =>
      [status, errorMassage, nom, time, count, nomBarcode];
}
