class ReturnNoms {
  final List<ReturnNom> noms;
  final String invoice;
  final String errorMassage;

  ReturnNoms(
      {required this.noms, required this.errorMassage, required this.invoice});

  static final empty =
      ReturnNoms(noms: [], invoice: '', errorMassage: 'Ok');
}

class ReturnNom {
  final String number;
  final String name;
  final String article;
  final List<Barcode> barcode;

  final double qty;
  final double count;
  final String nomStatus;

  ReturnNom({
    required this.number,
    required this.name,
    required this.article,
    required this.barcode,
    required this.qty,
    required this.count,
    required this.nomStatus
  });

  static final empty = ReturnNom(
    number: '',
    name: '',
    article: '',
    barcode: [],
    qty: 0,
    count: 0,
    nomStatus: ''
  );
}

class Barcode {
  final String barcode;
  final int ratio;

  Barcode({required this.barcode, required this.ratio});

  static final empty = Barcode(barcode: '', ratio: 0);
}

