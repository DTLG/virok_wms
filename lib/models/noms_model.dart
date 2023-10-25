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
  final String docNumber;
  final double qty;
  final double count;
  final String table;
  final int isMyne;
  final List<Bascket> basckets;

  Nom(
      {required this.name,
      required this.article,
      required this.barcode,
      required this.nameCell,
      required this.codeCell,
      required this.docNumber,
      required this.qty,
      required this.count,
      required this.table,
      required this.isMyne,
      required this.basckets});

  static final empty = Nom(
      name: '',
      article: '',
      barcode: [],
      nameCell: '',
      codeCell: '',
      docNumber: '',
      table: '',
      qty: 0,
      count: 0,
      isMyne: 0,
      basckets: [Bascket.empty]);
}

class Barcode {
  final String barcode;
  final int ratio;

  Barcode({required this.barcode, required this.ratio});

  static final empty = Barcode(barcode: '', ratio: 0);
}

class Bascket {
  final String bascket;
  final String name;

  Bascket({required this.bascket, required this.name});

  static final empty = Bascket(bascket: '', name: '');
}
