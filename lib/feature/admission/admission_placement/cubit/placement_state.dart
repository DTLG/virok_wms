part of 'placement_cubit.dart';

enum PlacementStatus { initial, loading, success, failure, notFound }

extension PlacementStatusX on PlacementStatus {
  bool get isInitial => this == PlacementStatus.initial;
  bool get isLoading => this == PlacementStatus.loading;
  bool get isSuccess => this == PlacementStatus.success;
  bool get isFailure => this == PlacementStatus.failure;
  bool get isNotFound => this == PlacementStatus.notFound;
}

final class PlacementState extends Equatable {
  PlacementState({
    this.status = PlacementStatus.initial,
    this.time = 0,
    PlacementNoms? noms,
    PlacementNom? nom,
    this.errorMassage = '',
  })  : noms = noms ?? PlacementNoms.empty,
        nom = nom ?? PlacementNom.empty;

  final PlacementStatus status;
  final PlacementNoms noms;
  final PlacementNom nom;

  final String errorMassage;
  final int time;

  PlacementState copyWith({
    PlacementStatus? status,
    PlacementNoms? noms,
    PlacementNom? nom,
    int? time,
    String? cell,
    double? count,
    String? nomBarcode,
    String? errorMassage,
  }) {
    return PlacementState(
      status: status ?? this.status,
      noms: noms ?? this.noms,
      nom: nom ?? this.nom,
      time: time ?? this.time,
      errorMassage: errorMassage ?? this.errorMassage,
    );
  }

  @override
  List<Object?> get props =>
      [status, noms, errorMassage, time, nom];
}
