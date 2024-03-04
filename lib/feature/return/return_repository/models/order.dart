import 'package:equatable/equatable.dart';

class ReturnOrders extends Equatable {
  final List<ReturnOrder> orders;
  final int status;

  const ReturnOrders({required this.orders, required this.status});

  @override
  List<Object?> get props => [orders, status];

  static const empty = ReturnOrders(orders: [], status: 1);
}

class ReturnOrder extends Equatable {
  final String docId;
  final String date;
  final String customer;
  final String invoice;

  const ReturnOrder(
      {required this.docId,
      required this.date,
      required this.customer,
      required this.invoice});

  @override
  List<Object?> get props => [docId, date, customer, invoice];

  static const empty =
      ReturnOrder(docId: '', date: '', customer: '', invoice: '');
}

