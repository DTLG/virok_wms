import 'package:equatable/equatable.dart';

class MovingInOrders extends Equatable {
  final List<MovingInOrder> orders;
  final int status;

  const MovingInOrders({required this.orders, required this.status});

  @override
  List<Object?> get props => [orders, status];

  static const empty = MovingInOrders(orders: [], status: 1);
}

class MovingInOrder extends Equatable {
  final String docId;
  final String date;
  final String customer;
  final String invoice;

  const MovingInOrder(
      {required this.docId,
      required this.date,
      required this.customer,
      required this.invoice});

  @override
  List<Object?> get props => [docId, date, customer, invoice];

  static const empty =
      MovingInOrder(docId: '', date: '', customer: '', invoice: '');
}

// class Bascet extends Equatable {
//   final String bascet;

//   const Bascet({required this.bascet});
//   static const empty = Bascet(bascet: '');

//   @override
//   List<Object?> get props => [bascet];
// }
