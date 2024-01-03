part of 'admission_placement_cubit.dart';

enum AdmissionPlacementStatus { initial, loading, success, failure, notFound }

extension PlacementStatusX on AdmissionPlacementStatus {
  bool get isInitial => this == AdmissionPlacementStatus.initial;
  bool get isLoading => this == AdmissionPlacementStatus.loading;
  bool get isSuccess => this == AdmissionPlacementStatus.success;
  bool get isFailure => this == AdmissionPlacementStatus.failure;
  bool get isNotFound => this == AdmissionPlacementStatus.notFound;
}

final class AdmissionPlacementState extends Equatable {
  AdmissionPlacementState({
    this.status = AdmissionPlacementStatus.initial,
    this.time = 0,
    this.cell = '',
    this.count = 0,
    this.nomBarcode = '',
    AdmissionNoms? noms,
    AdmissionNom? nom,
    this.errorMassage = '',
  })  : noms = noms ?? AdmissionNoms.empty,
        nom = nom ?? AdmissionNom.empty;

  final AdmissionPlacementStatus status;
  final AdmissionNoms noms;
  final AdmissionNom nom;

  final String errorMassage;
  final String nomBarcode;
  final int time;
  final String cell;
  final double count;

  AdmissionPlacementState copyWith({
    AdmissionPlacementStatus? status,
    AdmissionNoms? noms,
    AdmissionNom? nom,
    int? time,
    String? cell,
    double? count,
    String? nomBarcode,
    String? errorMassage,
  }) {
    return AdmissionPlacementState(
      status: status ?? this.status,
      noms: noms ?? this.noms,
      nom: nom ?? this.nom,
      time: time ?? this.time,
      cell: cell ?? this.cell,
      nomBarcode: nomBarcode ?? this.nomBarcode,
      count: count ?? this.count,
      errorMassage: errorMassage ?? this.errorMassage,
    );
  }

  @override
  List<Object?> get props =>
      [status, noms, errorMassage, time, cell, count, nomBarcode, nom];
}
