import 'package:equatable/equatable.dart';

class DisplacementNoms extends Equatable {
  final List<DisplacementNom> noms;
  final String invoice;
  final String? errorMassage;
  const DisplacementNoms(
      {required this.noms, required this.errorMassage, required this.invoice});

  factory DisplacementNoms.fromJson(Map<String, dynamic> json) =>
      DisplacementNoms(
        noms: ((json['noms'] ?? []) as List<dynamic>)
            .map((e) => DisplacementNom.fromJson(e as Map<String, dynamic>))
            .toList(),
        errorMassage: json['ErrorMassage'] ?? '',
        invoice: json['invoice'] ?? '',
      );

  static const empty =
      DisplacementNoms(noms: [], errorMassage: '', invoice: '');

  @override
  List<Object?> get props => [invoice, noms, errorMassage];
}

class DisplacementNom extends Equatable {
  final String number;
  final String name;
  final String article;
  final List<Barcode> barcodes;
  final int qty;
  final int count;

  const DisplacementNom({
    required this.name,
    required this.article,
    required this.barcodes,
    required this.number,
    required this.qty,
    required this.count,
  });

  factory DisplacementNom.fromJson(Map<String, dynamic> json) =>
      DisplacementNom(
        name: json['tovar'] ?? '',
        article: json['article'] ?? '',
        barcodes: ((json['barcodes'] ?? []) as List<dynamic>)
            .map((e) => Barcode.fromJson(e as Map<String, dynamic>))
            .toList(),
        number: json['number'] ?? '',
        qty: ((json['qty'] ?? 0) as num).toInt(),
        count: ((json['count'] ?? 0) as num).toInt(),
      );

  static const empty = DisplacementNom(
      name: '', article: '', barcodes: [], number: '', qty: 0, count: 0);

  @override
  List<Object?> get props => [name, article, barcodes, number, qty, count];
}

class Barcode extends Equatable {
  final String barcode;
  final int ratio;

  const Barcode({required this.barcode, required this.ratio});

  factory Barcode.fromJson(Map<String, dynamic> json) => Barcode(
        barcode: json['barcode'] ?? '',
        ratio: json['ratio'] ?? 0,
      );

  static const empty = Barcode(barcode: '', ratio: 0);

  @override
  List<Object?> get props => [barcode, ratio];
}

class Bascket extends Equatable {
  final String basket;
  final String basketName;

  const Bascket({required this.basket, required this.basketName});

  factory Bascket.fromJson(Map<String, dynamic> json) => Bascket(
        basket: json['basket'] ?? '',
        basketName: json['basketName'] ?? '',
      );

  static const empty = Bascket(basket: '', basketName: '');

  @override
  List<Object?> get props => [basket, basketName];
}

class Cell extends Equatable {
  final String codeCell;
  final String nameCell;

  const Cell({required this.codeCell, required this.nameCell});

  factory Cell.fromJson(Map<String, dynamic> json) => Cell(
        codeCell: json['code_cell'] ?? '',
        nameCell: json['name_cell'] ?? '',
      );

  static const empty = Cell(codeCell: '', nameCell: '');
  @override
  List<Object?> get props => [codeCell, nameCell];
}
