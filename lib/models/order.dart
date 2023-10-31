import 'package:equatable/equatable.dart';

class Orders extends Equatable {
  final List<Order> orders;
  final int status;

  const Orders({required this.orders, required this.status});

  @override
  List<Object?> get props => [orders, status];

  static const empty = Orders(orders: [], status: 1);
}

class Order extends Equatable {
  final String docId;
  final String date;
  final List<Bascet> baskets;

  const Order({required this.docId, required this.date, required this.baskets});

  @override
  List<Object?> get props => [docId, date, baskets];

  static const empty = Order(docId: '', date: '', baskets: []);
}

class Bascet extends Equatable {
  final String bascet;

  const Bascet({required this.bascet});
  static const empty = Bascet(bascet: '');

  @override
  List<Object?> get props => [bascet];
}
