class MovingInNoms {
  final List<MovingInNom> noms;
  final String invoice;
  final String errorMassage;

  MovingInNoms(
      {required this.noms, required this.errorMassage, required this.invoice});

  static final empty =
      MovingInNoms(noms: [], invoice: '', errorMassage: 'Ok');
}

class MovingInNom {
  final String number;
  final String name;
  final String article;
  final List<Barcode> barcode;

  final double qty;
  final double count;

  MovingInNom({
    required this.number,
    required this.name,
    required this.article,
    required this.barcode,
    required this.qty,
    required this.count,
  });

  static final empty = MovingInNom(
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
