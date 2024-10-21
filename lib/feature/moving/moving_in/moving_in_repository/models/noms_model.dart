class MovingInNoms {
  final List<MovingInNom> noms;
  final String invoice;
  final String errorMassage;

  MovingInNoms(
      {required this.noms, required this.errorMassage, required this.invoice});

  static final empty = MovingInNoms(noms: [], invoice: '', errorMassage: 'Ok');
}

class MovingInNom {
  final String number;
  final String name;
  final String article;
  final List<Barcode> barcodes;

  final int qty;
  final int count;

  MovingInNom({
    required this.number,
    required this.name,
    required this.article,
    required this.barcodes,
    required this.qty,
    required this.count,
  });

  static final empty = MovingInNom(
    number: '',
    name: '',
    article: '',
    barcodes: [],
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
