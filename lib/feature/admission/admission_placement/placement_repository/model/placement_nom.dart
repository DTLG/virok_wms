import '../../../../../models/barcode_model.dart';

class PlacementNoms {
  final List<PlacementNom> noms;
  final String errorMassage;

  PlacementNoms({
    required this.noms,
    required this.errorMassage
  });

  static final empty = PlacementNoms(noms: [], errorMassage: '');
}

class PlacementNom {
  final String name;
  final String article;
  final List<Barcode> barcodes;
  final double allCount;
  final double freeCount;
  final double reservedCount;

  PlacementNom(
      {required this.name,
      required this.article,
      required this.barcodes,
      required this.allCount,
      required this.freeCount,
      required this.reservedCount});

  static final empty = PlacementNom(
      name: '',
      article: '',
      barcodes: [],
      allCount: 0,
      freeCount: 0,
      reservedCount: 0);
}
