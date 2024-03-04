import 'package:virok_wms/feature/inventory/inventory_by_nom/models/barcode.dart';

class CellsByNom {
  final String nom;
  final String article;
  final List<Barcode> barcodes;
  final List<Cell> cells;
  final String docNumber;
  final String errorMassage;

  CellsByNom(
      {required this.nom,
      required this.article,
      required this.barcodes,
      required this.cells,
      required this.docNumber,
      required this.errorMassage});

  static final empty = CellsByNom(
      nom: '',
      article: '',
      barcodes: [],
      cells: [],
      docNumber: '',
      errorMassage: '');
}

class Cell {
  final String code;
  final String name;
  final int planCount;
  final int factCount;
  final String nomStatus;

  Cell(
      {required this.code,
      required this.name,
      required this.planCount,
      required this.factCount,
      required this.nomStatus});

  static final empty =
      Cell(code: '', name: '', planCount: 0, factCount: 0, nomStatus: '');
}
