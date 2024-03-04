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
    this.itsMezonine = false,
    this.errorMassage = '',
    this.time = 0,
    Orders? orders,
  }) : orders = orders ?? Orders.empty;

  final SelectioOrdersHeadStatus status;
  final bool itsMezonine;
  final Orders orders;
  final String errorMassage;
  final bool buskeStatus;
  final int time;

  SelectioOrdersHeadState copyWith(
      {SelectioOrdersHeadStatus? status,
      Orders? orders,
      String? errorMassage,
      int? time,
      bool? itsMezonine,
      bool? buskeStatus}) {
    return SelectioOrdersHeadState(
        status: status ?? this.status,
        orders: orders ?? this.orders,
        time: time ?? this.time,
        errorMassage: errorMassage ?? this.errorMassage,
        buskeStatus: buskeStatus ?? this.buskeStatus,
        itsMezonine: itsMezonine ?? this.itsMezonine);
  }

  @override
  List<Object?> get props =>
      [status, orders, errorMassage, buskeStatus, itsMezonine, time];
}
