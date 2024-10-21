part of 'order_route_info_cubit.dart';

// Define the state
abstract class OrderRouteInfoState extends Equatable {
  const OrderRouteInfoState();

  @override
  List<Object> get props => [];
}

class OrderRouteInfoInitial extends OrderRouteInfoState {}

class OrderRouteInfoLoading extends OrderRouteInfoState {}

class OrderRouteInfoLoaded extends OrderRouteInfoState {
  final OrderRouteInfo orderRouteInfo;

  OrderRouteInfoLoaded(this.orderRouteInfo);

  @override
  List<Object> get props => [orderRouteInfo];
}

class OrderRouteInfoError extends OrderRouteInfoState {
  final String error;

  OrderRouteInfoError(this.error);

  @override
  List<Object> get props => [error];
}
