import 'package:equatable/equatable.dart';

class Noms extends Equatable {
  final List<BarcodesNom> noms;

  const Noms({required this.noms});

  factory Noms.fromJson(Map<String, dynamic> json) => Noms(
        noms: (json['noms'] as List<dynamic>)
            .map((e) => BarcodesNom.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  static const empty = Noms(noms: []);
  @override
  List<Object?> get props => [noms];
}

class BarcodesNom extends Equatable {
  final String name;
  final String article;
  final List<Barcode> barcodes;
  final List<Cell> cells;
  int get totalCount {
    return cells.fold(
        0, (previousValue, cell) => previousValue + (cell.count).toInt());
  }

  factory BarcodesNom.fromJson(Map<String, dynamic> json) => BarcodesNom(
        name: json['tovar'] ?? '',
        article: json['article'] ?? '',
        barcodes: (json['barcodes'] as List<dynamic>)
            .map((e) => Barcode.fromJson(e as Map<String, dynamic>))
            .toList(),
        cells: (json['cells'] as List<dynamic>)
            .map((e) => Cell.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
  const BarcodesNom(
      {required this.name,
      required this.article,
      required this.barcodes,
      required this.cells});

  static const empty =
      BarcodesNom(name: '', article: '', barcodes: [], cells: []);

  @override
  List<Object?> get props => [name, article, barcodes, cells];
}

class Barcode {
  final String barcode;
  final int count;
  final double ratio;

  factory Barcode.fromJson(Map<String, dynamic> json) => Barcode(
        barcode: json['barcode'] ?? '',
        count: json['count'].toInt() ?? 0,
        ratio: json['ratio'] ?? 0.0,
      );
  // factory Barcode.fromJson(Map<String, dynamic> json) {
  //   double ratioValue = json['ratio'].toDouble();
  //   print('Type of json["ratio"]: ${ratioValue.runtimeType}');

  //   return Barcode(
  //     barcode: json['barcode'] ?? '',
  //     count: json['count'] ?? 0,
  //     ratio: ratioValue,
  //   );
  // }

  Barcode({required this.barcode, required this.count, required this.ratio});
}

class Cell {
  final String codeCell;
  final String nameCell;
  final num count;
  final String nomStatus;

  Cell(
      {required this.codeCell,
      required this.nameCell,
      required this.count,
      required this.nomStatus});

  factory Cell.fromJson(Map<String, dynamic> json) => Cell(
      codeCell: json['code_cell'] ?? '',
      nameCell: json['name_cell'] ?? '',
      count: json['count'] ?? 0,
      nomStatus: json['nom_status'] ?? '');
}
