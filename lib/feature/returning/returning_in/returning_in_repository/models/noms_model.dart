class ReturningInNoms {
  final List<ReturningInNom> noms;
  final String invoice;
  final String errorMassage;

  ReturningInNoms(
      {required this.noms, required this.errorMassage, required this.invoice});

  static final empty =
      ReturningInNoms(noms: [], invoice: '', errorMassage: 'Ok');
}

class ReturningInNom {
  final String number;
  final String name;
  final String article;
  final List<Barcode> barcode;

  final int qty;
  final int count;
  final String nomStatus;

  ReturningInNom(
      {required this.number,
      required this.name,
      required this.article,
      required this.barcode,
      required this.qty,
      required this.count,
      required this.nomStatus});

  static final empty = ReturningInNom(
      number: '',
      name: '',
      article: '',
      barcode: [],
      qty: 0,
      count: 0,
      nomStatus: '');
}

class Barcode {
  final String barcode;
  final int ratio;

  Barcode({required this.barcode, required this.ratio});

  static final empty = Barcode(barcode: '', ratio: 0);
}
