part of 'order_head_cubit.dart';

enum ShipmentStatus { initial, loading, success, failure, notFound }

extension ShipmentStatusX on ShipmentStatus {
  bool get isInitial => this == ShipmentStatus.initial;
  bool get isLoading => this == ShipmentStatus.loading;
  bool get isSuccess => this == ShipmentStatus.success;
  bool get isFailure => this == ShipmentStatus.failure;
}

final class ShipmentHeadState extends Equatable {
  const ShipmentHeadState({this.status = ShipmentStatus.initial, this.orders});

  final ShipmentStatus status;
  final Orders? orders;

  ShipmentHeadState copyWith({
    ShipmentStatus? status,
    Orders? orders,
  }) {
    return ShipmentHeadState(
        status: status ?? this.status, orders: orders ?? this.orders);
  }

  @override
  List<Object?> get props => [status, orders];
}
