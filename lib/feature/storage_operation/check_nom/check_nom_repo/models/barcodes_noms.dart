import 'package:equatable/equatable.dart';

class Noms extends Equatable {
  final List<BarcodesNom> noms;

  const Noms({required this.noms});

  @override
  List<Object?> get props => [noms];

  static const empty = Noms(noms: []);
}

class BarcodesNom extends Equatable {
  final String name;
  final String article;
  final List<Barcodee> barodes;
  final List<Cell> cells;
  final int totalCount;

  const BarcodesNom(
      {required this.name,
      required this.article,
      required this.barodes,
      required this.cells,
      required this.totalCount
      });

  @override
  List<Object?> get props => [name, article, barodes];

  static const empty =
      BarcodesNom(name: '', article: '', barodes: [], cells: [], totalCount: 0);
}

class Barcodee extends Equatable {
  final String barcode;
  final int count;
  final int ratio;

  const Barcodee(
      {required this.barcode, required this.count, required this.ratio});

  @override
  List<Object?> get props => [barcode, count, ratio];
}

class Cell extends Equatable{
  final String codeCell;
  final String nameCell;
  final double count;
  final String nomStatus;

  const Cell({required this.codeCell, required this.nameCell, required this.count, required this.nomStatus});

  static const empty =  Cell(codeCell: '', nameCell: '', count: 0, nomStatus: '');
  @override
  List<Object?> get props => [codeCell, nameCell, count];
}
