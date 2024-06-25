part of 'displacement_order_data_cubit.dart';

enum DisplacementOrderDataStatus {
  initial,
  loading,
  success,
  failure,
  notFound
}

extension DiplacementOrderDataStatusX on DisplacementOrderDataStatus {
  bool get isInitial => this == DisplacementOrderDataStatus.initial;
  bool get isLoading => this == DisplacementOrderDataStatus.loading;
  bool get isSuccess => this == DisplacementOrderDataStatus.success;
  bool get isFailure => this == DisplacementOrderDataStatus.failure;
  bool get isNotFound => this == DisplacementOrderDataStatus.notFound;
}

final class DisplacementOrderDataState extends Equatable {
  const DisplacementOrderDataState({
    this.status = DisplacementOrderDataStatus.initial,
    this.time = 0,
    DisplacementNoms? noms,
    DisplacementNom? nom,
    this.errorMassage = '',
  })  : noms = noms ?? DisplacementNoms.empty,
        nom = nom ?? DisplacementNom.empty;

  final DisplacementOrderDataStatus status;
  final DisplacementNoms noms;
  final DisplacementNom nom;

  final String errorMassage;
  final int time;

  DisplacementOrderDataState copyWith({
    DisplacementOrderDataStatus? status,
    DisplacementNoms? noms,
    DisplacementNom? nom,
    int? time,
    String? errorMassage,
  }) {
    return DisplacementOrderDataState(
      status: status ?? this.status,
      noms: noms ?? this.noms,
      nom: nom ?? this.nom,
      time: time ?? this.time,
      errorMassage: errorMassage ?? this.errorMassage,
    );
  }

  @override
  List<Object?> get props => [status, noms, errorMassage, time, nom];
}
