part of 'returning_in_data_cubit.dart';

enum ReturningInDataStatus { initial, loading, success, failure, notFound }

extension ReturningInDataStatusX on ReturningInDataStatus {
  bool get isInitial => this == ReturningInDataStatus.initial;
  bool get isLoading => this == ReturningInDataStatus.loading;
  bool get isSuccess => this == ReturningInDataStatus.success;
  bool get isFailure => this == ReturningInDataStatus.failure;
  bool get isNotFound => this == ReturningInDataStatus.notFound;
}

final class ReturningInDataState extends Equatable {
  ReturningInDataState({
    this.status = ReturningInDataStatus.initial,
    this.time = 0,
    ReturningInNoms? noms,
        ReturningInNom? nom,
        this.count = 0,

    this.errorMassage = '',
  }) : noms = noms ?? ReturningInNoms.empty,
   nom = nom ?? ReturningInNom.empty;

  final ReturningInDataStatus status;
  final ReturningInNoms noms;
    final ReturningInNom nom;
    final int count;

  final String errorMassage;
  final int time;

  ReturningInDataState copyWith({
    ReturningInDataStatus? status,
    ReturningInNoms? noms,
        ReturningInNom? nom,
        int? count,

    int? time,
    String? errorMassage,
  }) {
    return ReturningInDataState(
      status: status ?? this.status,
      noms: noms ?? this.noms,
            nom: nom ?? this.nom,
            count: count ?? this.count,

      time: time ?? this.time,
      errorMassage: errorMassage ?? this.errorMassage,
    );
  }

  @override
  List<Object?> get props => [status, noms, errorMassage, time, nom, count];
}
