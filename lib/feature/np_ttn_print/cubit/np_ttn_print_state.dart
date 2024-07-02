part of 'np_ttn_print_cubit.dart';

enum TtnPrintStatus { initial, loading, success, failure, error, emptyParamError }

enum MyAction { waiting, fetchingInfo, printing }

extension CheckttnStatusX on TtnPrintStatus {
  bool get isInitial => this == TtnPrintStatus.initial;
  bool get isLoading => this == TtnPrintStatus.loading;
  bool get isSuccess => this == TtnPrintStatus.success;
  bool get isFailure => this == TtnPrintStatus.failure;
  bool get isError => this == TtnPrintStatus.error;
}

extension CheckActionStatusX on MyAction {
  bool get isWaiting => this == MyAction.waiting;
  bool get isFetchingInfo => this == MyAction.fetchingInfo;
  bool get isPrinting => this == MyAction.printing;
}

class TtnPrintState extends Equatable {
  const TtnPrintState({
    this.action = MyAction.waiting,
    this.status = TtnPrintStatus.initial,
    this.errorMassage = '',
    TtnData? ttnData,
    List<TtnParams>? ttnParams,
  })  : ttnData = ttnData ?? TtnData.empty,
        ttnParams = ttnParams ?? const [];

  final TtnPrintStatus status;
  final TtnData ttnData;
  final List<TtnParams> ttnParams;
  final String errorMassage;
  final MyAction action;

  TtnPrintState copyWith({
    TtnPrintStatus? status,
    MyAction? action,
    String? errorMassage,
    TtnData? ttnData,
    List<TtnParams>? ttnParams,
  }) {
    return TtnPrintState(
        status: status ?? this.status,
        action: action ?? this.action,
        ttnData: ttnData ?? this.ttnData,
        ttnParams: ttnParams ?? this.ttnParams,
        errorMassage: errorMassage ?? this.errorMassage);
  }

  @override
  List<Object?> get props => [status, action, ttnData, ttnParams, errorMassage];
}
