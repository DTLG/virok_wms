part of 'returning_out_order_head_cubit.dart';

enum ReturningOutOrdersHeadStatus {
  initial,
  loading,
  success,
  failure,
  notFound
}

extension ReturningOrdersHeadStatusX on ReturningOutOrdersHeadStatus {
  bool get isInitial => this == ReturningOutOrdersHeadStatus.initial;
  bool get isLoading => this == ReturningOutOrdersHeadStatus.loading;
  bool get isSuccess => this == ReturningOutOrdersHeadStatus.success;
  bool get isFailure => this == ReturningOutOrdersHeadStatus.failure;
  bool get isNotFound => this == ReturningOutOrdersHeadStatus.notFound;
}

final class ReturningOutOrdersHeadState extends Equatable {
  const ReturningOutOrdersHeadState({
    this.status = ReturningOutOrdersHeadStatus.initial,
    this.buskeStatus = false,
    this.itsMezonine = false,
    this.errorMassage = '',
    this.time = 0,
    Orders? orders,
  }) : orders = orders ?? Orders.empty;

  final ReturningOutOrdersHeadStatus status;
  final bool itsMezonine;
  final Orders orders;
  final String errorMassage;
  final bool buskeStatus;
  final int time;

  ReturningOutOrdersHeadState copyWith(
      {ReturningOutOrdersHeadStatus? status,
      Orders? orders,
      String? errorMassage,
      bool? itsMezonine,
      int? time,
      bool? buskeStatus}) {
    return ReturningOutOrdersHeadState(
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
