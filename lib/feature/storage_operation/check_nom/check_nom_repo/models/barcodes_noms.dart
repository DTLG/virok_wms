import 'package:equatable/equatable.dart';

class BarcodesNoms extends Equatable {
  final List<BarcodesNom> noms;

  const BarcodesNoms({required this.noms});

  @override
  List<Object?> get props => [noms];

  static const empty = BarcodesNoms(noms: []);
}

class BarcodesNom extends Equatable {
  final String name;
  final String article;
  final List<Barcode> barodes;
  final List<Cell> cells;

  const BarcodesNom(
      {required this.name,
      required this.article,
      required this.barodes,
      required this.cells});

  @override
  List<Object?> get props => [name, article, barodes];

  static const empty =
      BarcodesNom(name: '', article: '', barodes: [], cells: []);
}

class Barcode extends Equatable {
  final String barcode;
  final int count;
  final int ratio;

  const Barcode(
      {required this.barcode, required this.count, required this.ratio});

  @override
  List<Object?> get props => [barcode, count, ratio];
}

class Cell extends Equatable{
  final String codeCell;
  final String nameCell;
  final double count;

  const Cell({required this.codeCell, required this.nameCell, required this.count});

  static const empty =  Cell(codeCell: '', nameCell: '', count: 0);
  @override
  List<Object?> get props => [codeCell, nameCell, count];
}
