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
    this.cell = '',
    this.count = 0,
    this.nomBarcode = '',
    AdmissionNoms? noms,
    AdmissionNom? nom,
    this.errorMassage = '',
  })  : noms = noms ?? AdmissionNoms.empty,
        nom = nom ?? AdmissionNom.empty;

  final PlacementStatus status;
  final AdmissionNoms noms;
  final AdmissionNom nom;

  final String errorMassage;
  final String nomBarcode;
  final int time;
  final String cell;
  final int count;

  PlacementState copyWith(
      {PlacementStatus? status,
      AdmissionNoms? noms,
      int? time,
      String? cell,
      int? count,
      String? nomBarcode,
      String? errorMassage,
      AdmissionNom? nom}) {
    return PlacementState(
        status: status ?? this.status,
        noms: noms ?? this.noms,
        time: time ?? this.time,
        cell: cell ?? this.cell,
        nomBarcode: nomBarcode ?? this.nomBarcode,
        count: count ?? this.count,
        errorMassage: errorMassage ?? this.errorMassage,
        nom: nom ?? this.nom);
  }

  @override
  List<Object?> get props =>
      [status, noms, errorMassage, time, cell, count, nomBarcode, nom];
}
