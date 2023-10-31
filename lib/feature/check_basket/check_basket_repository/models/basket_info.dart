import 'package:equatable/equatable.dart';

class BasketData extends Equatable {
  final String docNumber;
  final Table table;
  final String basket;

  const BasketData(
      {required this.docNumber, required this.table, required this.basket});

  static const empty =
      BasketData(docNumber: '', table: Table.empty, basket: '');

  @override
  List<Object?> get props => [docNumber, table, basket];
}

class Table extends Equatable {
  final String name;
  final String barcode;

  const Table({required this.name, required this.barcode});

  static const empty = Table(name: '', barcode: '');

  @override
  List<Object?> get props => [name, barcode];
}
