import 'package:json_annotation/json_annotation.dart';
import 'package:virok_wms/models/barcode_model.dart';

class Noms {
  final List<Nom> noms;
  final int status;

  Noms({required this.noms, required this.status});

  static final empty = Noms(noms: [], status: 1);
}

class Nom {
  final String name;
  final String article;
  final List<Barcode> barcode;
  final String nameCell;
  final String codeCell;
  final List<Cell> cells;
  final String docNumber;
  final double qty;
  final double count;
  final String table;
  final double isMyne;
  final List<Bascket> baskets;
  final String taskNumber;
  final String statusNom;

  Nom(
      {required this.name,
      required this.article,
      required this.barcode,
      required this.nameCell,
      required this.codeCell,
      required this.cells,
      required this.docNumber,
      required this.qty,
      required this.count,
      required this.table,
      required this.isMyne,
      required this.baskets,
      required this.taskNumber,
      required this.statusNom});

  static final empty = Nom(
      name: '',
      article: '',
      barcode: [],
      nameCell: '',
      codeCell: '',
      cells: [],
      docNumber: '',
      table: '',
      qty: 0,
      count: 0,
      isMyne: 0,
      taskNumber: '',
      baskets: [Bascket.empty],
      statusNom: '');
}

class Bascket {
  final String bascket;
  @JsonKey(name: 'basket_name')
  final String name;

  Bascket({required this.bascket, required this.name});

  static final empty = Bascket(bascket: '', name: '');
}

class Cell {
  final String codeCell;
  final String nameCell;

  Cell({required this.codeCell, required this.nameCell});

  static final empty = Cell(codeCell: '', nameCell: '');
}
