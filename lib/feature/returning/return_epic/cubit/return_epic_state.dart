part of 'return_epic_cubit.dart';

enum ReturningEpicStatus { initial, loading, success, failure, notFound }

extension ReturningEpicStatusX on ReturningEpicStatus {
  bool get isInitial => this == ReturningEpicStatus.initial;
  bool get isLoading => this == ReturningEpicStatus.loading;
  bool get isSuccess => this == ReturningEpicStatus.success;
  bool get isFailure => this == ReturningEpicStatus.failure;
  bool get isNotFound => this == ReturningEpicStatus.notFound;
}

final class ReturnEpicState extends Equatable {
  const ReturnEpicState({
    this.status = ReturningEpicStatus.initial,
    this.time = 0,
    ReturnEpicNoms? noms,
    ReturnEpicNom? nom,
    this.count = 0,
    this.errorMassage = '',
  })  : noms = noms ?? ReturnEpicNoms.empty,
        nom = nom ?? ReturnEpicNom.empty;

  final ReturningEpicStatus status;
  final ReturnEpicNoms noms;
  final ReturnEpicNom nom;
  final int count;

  final String errorMassage;
  final int time;

  ReturnEpicState copyWith({
    ReturningEpicStatus? status,
    ReturnEpicNoms? noms,
    ReturnEpicNom? nom,
    int? count,
    int? time,
    String? errorMassage,
  }) {
    return ReturnEpicState(
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
