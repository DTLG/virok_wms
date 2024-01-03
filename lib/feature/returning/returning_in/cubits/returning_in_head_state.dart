part of 'returning_in_head_cubit.dart';

enum ReturningInHeadStatus { initial, loading, success, failure, notFound }

extension ReturningInHeadStatusX on ReturningInHeadStatus {
  bool get isInitial => this == ReturningInHeadStatus.initial;
  bool get isLoading => this == ReturningInHeadStatus.loading;
  bool get isSuccess => this == ReturningInHeadStatus.success;
  bool get isFailure => this == ReturningInHeadStatus.failure;
  bool get isNotFound => this == ReturningInHeadStatus.notFound;
}

final class ReturningInHeadState extends Equatable {
  const ReturningInHeadState({
    this.status = ReturningInHeadStatus.initial,
    this.buskeStatus = false,
    this.itsMezonine = false,
    this.errorMassage = '',
    ReturningInOrders? orders,
  }) : orders = orders ?? ReturningInOrders.empty;

  final ReturningInHeadStatus status;
  final bool itsMezonine;
  final ReturningInOrders orders;
  final String errorMassage;
  final bool buskeStatus;

  ReturningInHeadState copyWith(
      {ReturningInHeadStatus? status, ReturningInOrders? orders, String? errorMassage,
      bool? itsMezonine,
      bool? buskeStatus}) {
    return ReturningInHeadState(
        status: status ?? this.status,
        orders: orders ?? this.orders,
        errorMassage: errorMassage ?? this.errorMassage,
        buskeStatus: buskeStatus ?? this.buskeStatus,
        itsMezonine: itsMezonine ?? this.itsMezonine);
  }

  @override
  List<Object?> get props => [status, orders, errorMassage, buskeStatus, itsMezonine];
}
