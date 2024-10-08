part of 'order_cubit.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final RouteData routeData;
  final List<OrderData> orders;

  const OrderLoaded({
    required this.routeData,
    required this.orders,
  });

  OrderLoaded copyWith({
    RouteData? routeData,
    List<OrderData>? orders,
  }) {
    return OrderLoaded(
      routeData: routeData ?? this.routeData,
      orders: orders ?? this.orders,
    );
  }

  @override
  List<Object> get props => [routeData, orders];
}

class OrderError extends OrderState {
  final String message;

  const OrderError(this.message);

  @override
  List<Object> get props => [message];
}
