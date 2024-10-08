part of 'placement_goods_cubit.dart';

enum PlacementGoodsStatus { initial, loading, success, failure, notFound }

extension PlacementGoodsStatusX on PlacementGoodsStatus {
  bool get isInitial => this == PlacementGoodsStatus.initial;
  bool get isLoading => this == PlacementGoodsStatus.loading;
  bool get isSuccess => this == PlacementGoodsStatus.success;
  bool get isFailure => this == PlacementGoodsStatus.failure;
  bool get isNotFound => this == PlacementGoodsStatus.notFound;
}

final class PlacementGoodsState extends Equatable {
  const PlacementGoodsState(
      {this.status = PlacementGoodsStatus.initial,
      this.count = 0,
      this.cellStatus = 1,
      this.cellBarcode = '',
      this.error = '',
      this.zoneStatus = 1,
      this.name = '',
      this.qty = '',
      this.article = '',
      this.cellIsEmpty = true,
      BarcodesNom? nom,
      Cell? cell,
      this.nomBarcode = ''})
      : cell = cell ?? Cell.empty,
        nom = nom ?? BarcodesNom.empty;

  final PlacementGoodsStatus status;
  final Cell cell;
  final String cellBarcode;
  final String nomBarcode;
  final double count;
  final int cellStatus;
  final String error;
  final int zoneStatus;
  final String name;
  final String article;
  final BarcodesNom nom;
  final String qty;
  final bool cellIsEmpty;

  PlacementGoodsState copyWith(
      {PlacementGoodsStatus? status,
      Cell? cell,
      String? nomBarcode,
      String? cellBarcode,
      String? error,
      double? count,
      String? name,
      String? qty,
      String? article,
      BarcodesNom? nom,
      bool? cellIsEmpty,
      int? cellStatus,
      int? zoneStatus}) {
    return PlacementGoodsState(
        status: status ?? this.status,
        cell: cell ?? this.cell,
        nomBarcode: nomBarcode ?? this.nomBarcode,
        cellBarcode: cellBarcode ?? this.cellBarcode,
        count: count ?? this.count,
        cellStatus: cellStatus ?? this.cellStatus,
        error: error ?? this.error,
        name: name ?? this.name,
        qty: qty ?? this.qty,
        article: article ?? this.article,
        zoneStatus: zoneStatus ?? this.zoneStatus,
        nom: nom ?? this.nom,
        cellIsEmpty: cellIsEmpty ?? this.cellIsEmpty);
  }

  @override
  List<Object?> get props => [
        status,
        cell,
        nomBarcode,
        count,
        cellStatus,
        cellBarcode,
        error,
        zoneStatus,
        name,
        qty,
        article,
        nom,
        cellIsEmpty
      ];
}
