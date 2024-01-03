part of 'moving_in_data_cubit.dart';

enum MovingInDataStatus { initial, loading, success, failure, notFound }

extension MovingInDataStatusX on MovingInDataStatus {
  bool get isInitial => this == MovingInDataStatus.initial;
  bool get isLoading => this == MovingInDataStatus.loading;
  bool get isSuccess => this == MovingInDataStatus.success;
  bool get isFailure => this == MovingInDataStatus.failure;
  bool get isNotFound => this == MovingInDataStatus.notFound;
}

final class MovingInDataState extends Equatable {
  MovingInDataState(
      {this.status = MovingInDataStatus.initial,
      this.time = 0,
      MovingInNoms? noms,
      this.errorMassage = '',
})
      : noms = noms ?? MovingInNoms.empty;
      

  final MovingInDataStatus status;
  final MovingInNoms noms;
  final String errorMassage;
  final int time;



  MovingInDataState copyWith(
      {MovingInDataStatus? status,
      MovingInNoms? noms,
      int? time,
      String? errorMassage,
    }) {
    return MovingInDataState(
        status: status ?? this.status,
        noms: noms ?? this.noms,
        time: time ?? this.time,
        errorMassage: errorMassage ?? this.errorMassage,
);
  }

  @override
  List<Object?> get props => [status, noms, errorMassage, time];
}
