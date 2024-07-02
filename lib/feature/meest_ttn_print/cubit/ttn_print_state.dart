part of 'ttn_print_cubit.dart';

enum TtnPrintStatus {
  initial,
  loading,
  success,
  failure,
  error,
  emptyParamError
}

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

final class TtnPrintState extends Equatable {
  const TtnPrintState({
    this.printValue = '',
    this.action = MyAction.waiting,
    this.status = TtnPrintStatus.initial,
    this.receiverInfo = const {},
    this.errorMassage = '',
  });

  final TtnPrintStatus status;
  final String errorMassage;
  final MyAction action;
  final String printValue;
  final Map<String, String> receiverInfo;

  TtnPrintState copyWith({
    TtnPrintStatus? status,
    MyAction? action,
    String? printValue,
    Map<String, String>? receiverInfo,
    String? errorMassage,
  }) {
    return TtnPrintState(
        status: status ?? this.status,
        action: action ?? this.action,
        receiverInfo: receiverInfo ?? this.receiverInfo,
        printValue: printValue ?? this.printValue,
        errorMassage: errorMassage ?? this.errorMassage);
  }

  @override
  List<Object?> get props => [status, action, errorMassage, receiverInfo, printValue];
}
