import 'package:equatable/equatable.dart';

class DisplacementOrders extends Equatable {
  final List<DisplacementOrder> orders;
  final int status;

  const DisplacementOrders({required this.orders, required this.status});

  @override
  List<Object?> get props => [orders, status];

  static const empty = DisplacementOrders(orders: [], status: 1);
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

  @override
  List<Object?> get props => [docId, date, customer, invoice];

  static const empty =
      DisplacementOrder(docId: '', date: '', customer: '', invoice: '');
}

// class Bascet extends Equatable {
//   final String bascet;

//   const Bascet({required this.bascet});
//   static const empty = Bascet(bascet: '');

//   @override
//   List<Object?> get props => [bascet];
// }
