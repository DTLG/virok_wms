import 'package:equatable/equatable.dart';

class Orders extends Equatable {
  final List<Order> orders;

  const Orders({required this.orders});

  @override
  List<Object?> get props => [orders];
}

class Order extends Equatable {
  final String docId;
  final String date;
  final String client;

  const Order({required this.docId, required this.date, required this.client});

  @override
  List<Object?> get props => [docId, date, client];
}
