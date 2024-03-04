part of 'return_data_cubit.dart';

enum ReturnDataStatus { initial, loading, success, failure, notFound }

extension ReturnDataStatusX on ReturnDataStatus {
  bool get isInitial => this == ReturnDataStatus.initial;
  bool get isLoading => this == ReturnDataStatus.loading;
  bool get isSuccess => this == ReturnDataStatus.success;
  bool get isFailure => this == ReturnDataStatus.failure;
  bool get isNotFound => this == ReturnDataStatus.notFound;
}

final class ReturnDataState extends Equatable {
  ReturnDataState({
    this.status = ReturnDataStatus.initial,
    this.time = 0,
    ReturnNoms? noms,
        ReturnNom? nom,
        this.count = 0,

    this.errorMassage = '',
  }) : noms = noms ?? ReturnNoms.empty,
   nom = nom ?? ReturnNom.empty;

  final ReturnDataStatus status;
  final ReturnNoms noms;
    final ReturnNom nom;
    final int count;

  final String errorMassage;
  final int time;

  ReturnDataState copyWith({
    ReturnDataStatus? status,
    ReturnNoms? noms,
        ReturnNom? nom,
        int? count,

    int? time,
    String? errorMassage,
  }) {
    return ReturnDataState(
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
