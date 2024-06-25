part of 'ttn_print_cubit.dart';

enum TtnPrintStatus { initial, loading, success, failure, error }

extension TtnPrintStatusX on TtnPrintStatus {
  bool get isInitial => this == TtnPrintStatus.initial;
  bool get isLoading => this == TtnPrintStatus.loading;
  bool get isSuccess => this == TtnPrintStatus.success;
  bool get isFailure => this == TtnPrintStatus.failure;
  bool get isError => this == TtnPrintStatus.error;
}

final class TtnPrintState {
  const TtnPrintState(
      {this.status = TtnPrintStatus.initial,
      this.errorMassage = '',
      TtnData? ttnData})
      : ttnData = ttnData ?? TtnData.empty;

  final TtnPrintStatus status;
  final TtnData ttnData;
  final String errorMassage;

  TtnPrintState copyWith({
    TtnPrintStatus? status,
    TtnData? ttnData,
    String? errorMassage,
  }) {
    return TtnPrintState(
        status: status ?? this.status,
        ttnData: ttnData ?? this.ttnData,
        errorMassage: errorMassage ?? this.errorMassage);
  }

  @override
  List<Object?> get props => [status, ttnData, errorMassage];
}
