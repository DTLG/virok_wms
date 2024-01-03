import 'package:equatable/equatable.dart';

class ReturningInOrders extends Equatable {
  final List<ReturningInOrder> orders;
  final int status;

  const ReturningInOrders({required this.orders, required this.status});

  @override
  List<Object?> get props => [orders, status];

  static const empty = ReturningInOrders(orders: [], status: 1);
}

class ReturningInOrder extends Equatable {
  final String docId;
  final String date;
  final String customer;
  final String invoice;

  const ReturningInOrder(
      {required this.docId,
      required this.date,
      required this.customer,
      required this.invoice});

  @override
  List<Object?> get props => [docId, date, customer, invoice];

  static const empty =
      ReturningInOrder(docId: '', date: '', customer: '', invoice: '');
}

