part of 'order_head_cubit.dart';

enum SelectionOrderHeadStatus { initial, loading, success, failure, notFound }

extension SelectionOrderHeadStatusX on SelectionOrderHeadStatus {
  bool get isInitial => this == SelectionOrderHeadStatus.initial;
  bool get isLoading => this == SelectionOrderHeadStatus.loading;
  bool get isSuccess => this == SelectionOrderHeadStatus.success;
  bool get isFailure => this == SelectionOrderHeadStatus.failure;
}

final class SelectionOrderHeadState extends Equatable {
  const SelectionOrderHeadState(
      {this.status = SelectionOrderHeadStatus.initial, Orders? orders, this.errorMassage = ''})
      : orders = orders ?? Orders.empty;

  final SelectionOrderHeadStatus status;
  final Orders orders;
  final String errorMassage;


  SelectionOrderHeadState copyWith({
    SelectionOrderHeadStatus? status,
    Orders? orders,
    String? errorMassage,
  }) {
    return SelectionOrderHeadState(
        status: status ?? this.status, orders: orders ?? this.orders,
        errorMassage: errorMassage ?? this.errorMassage);
  }

  @override
  List<Object?> get props => [status, orders, errorMassage];
}
