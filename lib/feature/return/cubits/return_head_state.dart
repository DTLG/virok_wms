part of 'return_head_cubit.dart';

enum ReturnHeadStatus { initial, loading, success, failure, notFound }

extension ReturnHeadStatusX on ReturnHeadStatus {
  bool get isInitial => this == ReturnHeadStatus.initial;
  bool get isLoading => this == ReturnHeadStatus.loading;
  bool get isSuccess => this == ReturnHeadStatus.success;
  bool get isFailure => this == ReturnHeadStatus.failure;
  bool get isNotFound => this == ReturnHeadStatus.notFound;
}

final class ReturnHeadState extends Equatable {
  const ReturnHeadState({
    this.status = ReturnHeadStatus.initial,
    this.buskeStatus = false,
    this.itsMezonine = false,
    this.errorMassage = '',
    ReturnOrders? orders,
  }) : orders = orders ?? ReturnOrders.empty;

  final ReturnHeadStatus status;
  final bool itsMezonine;
  final ReturnOrders orders;
  final String errorMassage;
  final bool buskeStatus;

  ReturnHeadState copyWith(
      {ReturnHeadStatus? status, ReturnOrders? orders, String? errorMassage,
      bool? itsMezonine,
      bool? buskeStatus}) {
    return ReturnHeadState(
        status: status ?? this.status,
        orders: orders ?? this.orders,
        errorMassage: errorMassage ?? this.errorMassage,
        buskeStatus: buskeStatus ?? this.buskeStatus,
        itsMezonine: itsMezonine ?? this.itsMezonine);
  }

  @override
  List<Object?> get props => [status, orders, errorMassage, buskeStatus, itsMezonine];
}
