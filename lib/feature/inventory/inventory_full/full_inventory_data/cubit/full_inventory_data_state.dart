part of 'full_inventory_data_cubit.dart';

enum FullInventoryStatus { initial, loading, success, failure, notFound }

extension Inventorystatusx on FullInventoryStatus {
  bool get isInitial => this == FullInventoryStatus.initial;
  bool get isLoading => this == FullInventoryStatus.loading;
  bool get isSuccess => this == FullInventoryStatus.success;
  bool get isFailure => this == FullInventoryStatus.failure;
  bool get isNotFound => this == FullInventoryStatus.notFound;
}

final class FullInventoryDataState extends Equatable {
  FullInventoryDataState({
    this.status = FullInventoryStatus.initial,
    this.time = 0,
    this.nomBarcode = '',
    this.count = 0,
    Inventory? nom,
    Inventory? selectNom,
    this.errorMassage = '',
  })  : nom = nom ?? Inventory.empty,
        selectNom = selectNom ?? Inventory.empty;

  final FullInventoryStatus status;
  final Inventory nom;
  final Inventory selectNom;

  final int time;
  final int count;
  final String nomBarcode;
  final String errorMassage;

  FullInventoryDataState copyWith(
      {FullInventoryStatus? status,
      int? time,
      Inventory? nom,
      Inventory? selectNom,
      String? errorMassage,
      String? nomBarcode,
      int? count}) {
    return FullInventoryDataState(
        status: status ?? this.status,
        nom: nom ?? this.nom,
        selectNom: selectNom ?? this.selectNom,
        errorMassage: errorMassage ?? this.errorMassage,
        time: time ?? this.time,
        count: count ?? this.count,
        nomBarcode: nomBarcode ?? this.nomBarcode);
  }

  @override
  List<Object?> get props =>
      [status, errorMassage, nom, time, count, nomBarcode, selectNom];
}
