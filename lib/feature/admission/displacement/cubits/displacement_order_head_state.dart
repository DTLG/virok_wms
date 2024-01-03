part of 'displacement_order_head_cubit.dart';

enum DisplacementOrdersHeadStatus { initial, loading, success, failure, notFound }

extension DisplacementOrdersHeadStatusX on DisplacementOrdersHeadStatus {
  bool get isInitial => this == DisplacementOrdersHeadStatus.initial;
  bool get isLoading => this == DisplacementOrdersHeadStatus.loading;
  bool get isSuccess => this == DisplacementOrdersHeadStatus.success;
  bool get isFailure => this == DisplacementOrdersHeadStatus.failure;
  bool get isNotFound => this == DisplacementOrdersHeadStatus.notFound;
}

final class DisplacementOrdersHeadState extends Equatable {
  const DisplacementOrdersHeadState({
    this.status = DisplacementOrdersHeadStatus.initial,
    this.buskeStatus = false,
    this.itsMezonine = false,
    this.errorMassage = '',
    DisplacementOrders? orders,
  }) : orders = orders ?? DisplacementOrders.empty;

  final DisplacementOrdersHeadStatus status;
  final bool itsMezonine;
  final DisplacementOrders orders;
  final String errorMassage;
  final bool buskeStatus;

  DisplacementOrdersHeadState copyWith(
      {DisplacementOrdersHeadStatus? status, DisplacementOrders? orders, String? errorMassage,
      bool? itsMezonine,
      bool? buskeStatus}) {
    return DisplacementOrdersHeadState(
        status: status ?? this.status,
        orders: orders ?? this.orders,
        errorMassage: errorMassage ?? this.errorMassage,
        buskeStatus: buskeStatus ?? this.buskeStatus,
        itsMezonine: itsMezonine ?? this.itsMezonine);
  }

  @override
  List<Object?> get props => [status, orders, errorMassage, buskeStatus, itsMezonine];
}
