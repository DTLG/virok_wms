part of 'selection_order_head_cubit.dart';

enum SelectioOrdersHeadStatus { initial, loading, success, failure, notFound }

extension SelectioOrdersHeadStatusX on SelectioOrdersHeadStatus {
  bool get isInitial => this == SelectioOrdersHeadStatus.initial;
  bool get isLoading => this == SelectioOrdersHeadStatus.loading;
  bool get isSuccess => this == SelectioOrdersHeadStatus.success;
  bool get isFailure => this == SelectioOrdersHeadStatus.failure;
  bool get isNotFound => this == SelectioOrdersHeadStatus.notFound;
}

final class SelectioOrdersHeadState extends Equatable {
  const SelectioOrdersHeadState({
    this.status = SelectioOrdersHeadStatus.initial,
    this.buskeStatus = false,
    this.errorMassage = '',
    Orders? orders,
  }) : orders = orders ?? Orders.empty;

  final SelectioOrdersHeadStatus status;
  final Orders orders;
  final String errorMassage;
  final bool buskeStatus;

  SelectioOrdersHeadState copyWith(
      {SelectioOrdersHeadStatus? status, Orders? orders, String? errorMassage,
      bool? buskeStatus}) {
    return SelectioOrdersHeadState(
        status: status ?? this.status,
        orders: orders ?? this.orders,
        errorMassage: errorMassage ?? this.errorMassage,
        buskeStatus: buskeStatus ?? this.buskeStatus);
  }

  @override
  List<Object?> get props => [status, orders, errorMassage, buskeStatus];
}
