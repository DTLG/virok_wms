part of 'placement_orders_cubit.dart';

enum PlacemenFromAdmissionHeadStatus { initial, loading, success, failure, notFound }

extension PlacementStatusX on PlacemenFromAdmissionHeadStatus {
  bool get isInitial => this == PlacemenFromAdmissionHeadStatus.initial;
  bool get isLoading => this == PlacemenFromAdmissionHeadStatus.loading;
  bool get isSuccess => this == PlacemenFromAdmissionHeadStatus.success;
  bool get isFailure => this == PlacemenFromAdmissionHeadStatus.failure;
  bool get isNotFound => this == PlacemenFromAdmissionHeadStatus.notFound;
}

 class PlacementFromAdmissionheadState extends Equatable {
  PlacementFromAdmissionheadState({
    this.status = PlacemenFromAdmissionHeadStatus.initial,
    this.time = 0,
    PlacementOrders? orders,
    this.errorMassage = '',
  }) : orders = orders ?? PlacementOrders.empty;

  final PlacemenFromAdmissionHeadStatus status;
  final PlacementOrders orders;

  final String errorMassage;
  final int time;

  PlacementFromAdmissionheadState copyWith({
    PlacemenFromAdmissionHeadStatus? status,
    PlacementOrders? orders,
    int? time,
    String? errorMassage,
  }) {
    return PlacementFromAdmissionheadState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      time: time ?? this.time,
      errorMassage: errorMassage ?? this.errorMassage,
    );
  }

  @override
  List<Object?> get props => [status, orders, errorMassage, time];
}
