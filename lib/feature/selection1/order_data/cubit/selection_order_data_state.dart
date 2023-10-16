part of 'selection_order_data_cubit.dart';

enum SelectionOrderDataStatus { initial, loading, success, failure, notFound }

extension SelectionOrderHeadStatusX on SelectionOrderDataStatus {
  bool get isInitial => this == SelectionOrderDataStatus.initial;
  bool get isLoading => this == SelectionOrderDataStatus.loading;
  bool get isSuccess => this == SelectionOrderDataStatus.success;
  bool get isFailure => this == SelectionOrderDataStatus.failure;
}

final class SelectionOrderDataState extends Equatable {
  SelectionOrderDataState(
      {this.status = SelectionOrderDataStatus.initial,
      Noms? noms,
      this.errorMassage = '',
      this.orderStatus = 0
      })
      : noms = noms ?? Noms.empty;

  final SelectionOrderDataStatus status;
  final Noms noms;
  final String errorMassage;
  final int orderStatus;

  SelectionOrderDataState copyWith({
    SelectionOrderDataStatus? status,
    Noms? noms,
    String? errorMassage,
    int? orderStatus
  }) {
    return SelectionOrderDataState(
        status: status ?? this.status,
        noms: noms ?? this.noms,
        errorMassage: errorMassage ?? this.errorMassage,
        orderStatus: orderStatus ?? this.orderStatus);
  }

  @override
  List<Object?> get props => [status, noms, errorMassage, orderStatus];
}
