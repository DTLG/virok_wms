part of 'recharge_cubit.dart';

enum RechargeStatus { initial, loading, success, failure, notFound }

extension RechargeStatusX on RechargeStatus {
  bool get isInitial => this == RechargeStatus.initial;
  bool get isLoading => this == RechargeStatus.loading;
  bool get isSuccess => this == RechargeStatus.success;
  bool get isFailure => this == RechargeStatus.failure;
  bool get isNotFound => this == RechargeStatus.notFound;
}

class RechargeState extends Equatable {
  RechargeState({
    this.status = RechargeStatus.initial,
    this.time = 0,
    this.errorMassage = '',
    this.cell = '',
    this.count = 0,
    this.nomBarcode = '',
    RechargeNoms? noms,
  }) : noms = noms ?? RechargeNoms.empty;

  final RechargeStatus status;
  final RechargeNoms noms;
  final String errorMassage;
  final String nomBarcode;
  final String cell;
  final int time;
  final double count;

  RechargeState copyWith(
      {RechargeStatus? status,
      RechargeNoms? noms,
      int? time,
      String? errorMassage,
      String? cell,
      double? count,
      String? nomBarcode}) {
    return RechargeState(
      status: status ?? this.status,
      noms: noms ?? this.noms,
      time: time ?? this.time,
      cell: cell ?? this.cell,
      count: count ?? this.count,
      nomBarcode: nomBarcode ?? this.nomBarcode,
      errorMassage: errorMassage ?? this.errorMassage,
    );
  }

  @override
  List<Object?> get props =>
      [status, noms, errorMassage, time, count, nomBarcode, cell];
}
