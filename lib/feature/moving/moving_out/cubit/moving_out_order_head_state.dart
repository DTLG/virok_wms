part of 'moving_out_order_head_cubit.dart';

enum MovingOutOrdersHeadStatus { initial, loading, success, failure, notFound }

extension MovingOrdersHeadStatusX on MovingOutOrdersHeadStatus {
  bool get isInitial => this == MovingOutOrdersHeadStatus.initial;
  bool get isLoading => this == MovingOutOrdersHeadStatus.loading;
  bool get isSuccess => this == MovingOutOrdersHeadStatus.success;
  bool get isFailure => this == MovingOutOrdersHeadStatus.failure;
  bool get isNotFound => this == MovingOutOrdersHeadStatus.notFound;
}

final class MovingOutOrdersHeadState extends Equatable {
  const MovingOutOrdersHeadState({
    this.status = MovingOutOrdersHeadStatus.initial,
    this.buskeStatus = false,
    this.itsMezonine = false,
    this.errorMassage = '',
    Orders? orders,
  }) : orders = orders ?? Orders.empty;

  final MovingOutOrdersHeadStatus status;
  final bool itsMezonine;
  final Orders orders;
  final String errorMassage;
  final bool buskeStatus;

  MovingOutOrdersHeadState copyWith(
      {MovingOutOrdersHeadStatus? status, Orders? orders, String? errorMassage,
      bool? itsMezonine,
      bool? buskeStatus}) {
    return MovingOutOrdersHeadState(
        status: status ?? this.status,
        orders: orders ?? this.orders,
        errorMassage: errorMassage ?? this.errorMassage,
        buskeStatus: buskeStatus ?? this.buskeStatus,
        itsMezonine: itsMezonine ?? this.itsMezonine);
  }

  @override
  List<Object?> get props => [status, orders, errorMassage, buskeStatus, itsMezonine];
}
