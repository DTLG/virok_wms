part of 'placement_orders_cubit.dart';

enum PlacementStatus { initial, loading, success, failure, notFound }

extension PlacementStatusX on PlacementStatus {
  bool get isInitial => this == PlacementStatus.initial;
  bool get isLoading => this == PlacementStatus.loading;
  bool get isSuccess => this == PlacementStatus.success;
  bool get isFailure => this == PlacementStatus.failure;
  bool get isNotFound => this == PlacementStatus.notFound;
}

 class PlacementOrderState extends Equatable {
  PlacementOrderState({
    this.status = PlacementStatus.initial,
    this.time = 0,
    PlacementOrders? orders,
    this.errorMassage = '',
  }) : orders = orders ?? PlacementOrders.empty;

  final PlacementStatus status;
  final PlacementOrders orders;

  final String errorMassage;
  final int time;

  PlacementOrderState copyWith({
    PlacementStatus? status,
    PlacementOrders? orders,
    int? time,
    String? errorMassage,
  }) {
    return PlacementOrderState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      time: time ?? this.time,
      errorMassage: errorMassage ?? this.errorMassage,
    );
  }

  @override
  List<Object?> get props => [status, orders, errorMassage, time];
}
