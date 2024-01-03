class DisplacementNoms {
  final List<DisplacementNom> noms;
  final String invoice;
  final String errorMassage;

  DisplacementNoms(
      {required this.noms, required this.errorMassage, required this.invoice});

  static final empty =
      DisplacementNoms(noms: [], invoice: '', errorMassage: 'Ok');
}

class DisplacementNom {
  final String number;
  final String name;
  final String article;
  final List<Barcode> barcode;

  final double qty;
  final double count;

  DisplacementNom({
    required this.number,
    required this.name,
    required this.article,
    required this.barcode,
    required this.qty,
    required this.count,
  });

  static final empty = DisplacementNom(
    number: '',
    name: '',
    article: '',
    barcode: [],
    qty: 0,
    count: 0,
  );
}

class Barcode {
  final String barcode;
  final int ratio;

  Barcode({required this.barcode, required this.ratio});

  static final empty = Barcode(barcode: '', ratio: 0);
}
