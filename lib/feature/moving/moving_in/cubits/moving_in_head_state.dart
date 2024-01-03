part of 'moving_in_head_cubit.dart';

enum MovingInHeadStatus { initial, loading, success, failure, notFound }

extension MovingInHeadStatusX on MovingInHeadStatus {
  bool get isInitial => this == MovingInHeadStatus.initial;
  bool get isLoading => this == MovingInHeadStatus.loading;
  bool get isSuccess => this == MovingInHeadStatus.success;
  bool get isFailure => this == MovingInHeadStatus.failure;
  bool get isNotFound => this == MovingInHeadStatus.notFound;
}

final class MovingInHeadState extends Equatable {
  const MovingInHeadState({
    this.status = MovingInHeadStatus.initial,
    this.buskeStatus = false,
    this.itsMezonine = false,
    this.errorMassage = '',
    MovingInOrders? orders,
  }) : orders = orders ?? MovingInOrders.empty;

  final MovingInHeadStatus status;
  final bool itsMezonine;
  final MovingInOrders orders;
  final String errorMassage;
  final bool buskeStatus;

  MovingInHeadState copyWith(
      {MovingInHeadStatus? status, MovingInOrders? orders, String? errorMassage,
      bool? itsMezonine,
      bool? buskeStatus}) {
    return MovingInHeadState(
        status: status ?? this.status,
        orders: orders ?? this.orders,
        errorMassage: errorMassage ?? this.errorMassage,
        buskeStatus: buskeStatus ?? this.buskeStatus,
        itsMezonine: itsMezonine ?? this.itsMezonine);
  }

  @override
  List<Object?> get props => [status, orders, errorMassage, buskeStatus, itsMezonine];
}
