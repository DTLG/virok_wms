import 'package:equatable/equatable.dart';

class DisplacementOrders extends Equatable {
  final List<DisplacementOrder> orders;
  final int status;

  const DisplacementOrders({required this.orders, required this.status});
  factory DisplacementOrders.fromJson(Map<String, dynamic> json) =>
      DisplacementOrders(
        orders: (json['IncomingInvoices'] as List<dynamic>)
            .map((e) => DisplacementOrder.fromJson(e as Map<String, dynamic>))
            .toList(),
        status: json['status'] ?? 0,
      );

  static const empty = DisplacementOrders(orders: [], status: 0);

  @override
  List<Object?> get props => [orders, status];
}

class DisplacementOrder extends Equatable {
  final String docId;
  final String date;

  final String customer;
  final String invoice;

  const DisplacementOrder(
      {required this.docId,
      required this.date,
      required this.customer,
      required this.invoice});

  factory DisplacementOrder.fromJson(Map<String, dynamic> json) =>
      DisplacementOrder(
        docId: json['number'] ?? '',
        date: json['date'] ?? '',
        customer: json['Сustomer'] ?? '',
        invoice: json['invoice'] ?? '',
      );

  static const empty =
      DisplacementOrder(docId: '', date: '', customer: '', invoice: '');

  @override
  List<Object?> get props => [docId, date, customer, invoice];
}
