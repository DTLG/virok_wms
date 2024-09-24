import 'package:virok_wms/models/barcode_model.dart';

class CheckCell {
  final String codCell;
  final String nameCell;
  final List<Nom> noms;

  final String errorMasssage;

  CheckCell(
      {required this.codCell,
      required this.nameCell,
      required this.noms,
      required this.errorMasssage});

  static final empty =
      CheckCell(codCell: '', nameCell: '', noms: [], errorMasssage: '');
}

class Nom {
  final String name;
  final String article;
  final double qty;
  final double minRest;
  final List<Barcode> barcodes;

  Nom(
      {required this.name,
      required this.article,
      required this.qty,
      required this.minRest,
      required this.barcodes});

  static final empty =
      Nom(name: '', article: '', qty: 0, minRest: 0, barcodes: []);
}
