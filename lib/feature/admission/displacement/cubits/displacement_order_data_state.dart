part of 'displacement_order_data_cubit.dart';

enum DisplacementOrderDataStatus { initial, loading, success, failure, notFound }

extension DiplacementOrderDataStatusX on DisplacementOrderDataStatus {
  bool get isInitial => this == DisplacementOrderDataStatus.initial;
  bool get isLoading => this == DisplacementOrderDataStatus.loading;
  bool get isSuccess => this == DisplacementOrderDataStatus.success;
  bool get isFailure => this == DisplacementOrderDataStatus.failure;
  bool get isNotFound => this == DisplacementOrderDataStatus.notFound;
}

final class DiplacementOrderDataState extends Equatable {
  DiplacementOrderDataState(
      {this.status = DisplacementOrderDataStatus.initial,
      this.time = 0,
      DisplacementNoms? noms,
      this.errorMassage = '',
})
      : noms = noms ?? DisplacementNoms.empty;
      

  final DisplacementOrderDataStatus status;
  final DisplacementNoms noms;
  final String errorMassage;
  final int time;



  DiplacementOrderDataState copyWith(
      {DisplacementOrderDataStatus? status,
      DisplacementNoms? noms,
      int? time,
      String? errorMassage,
    }) {
    return DiplacementOrderDataState(
        status: status ?? this.status,
        noms: noms ?? this.noms,
        time: time ?? this.time,
        errorMassage: errorMassage ?? this.errorMassage,
);
  }

  @override
  List<Object?> get props => [status, noms, errorMassage, time];
}
