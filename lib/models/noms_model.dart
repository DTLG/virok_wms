class Noms {
  final List<Nom> noms;
  final int status;

  Noms({required this.noms, required this.status});

  static final empty = Noms(noms: [], status: 1);
}

class Nom {
  final String name;
  final String article;
  final String barcode;
  final String nameCell;
  final String codeCell;
  final String docId;
  final double qty;
  final double count;

  Nom({
    required this.name,
    required this.article,
    required this.barcode,
    required this.nameCell,
    required this.codeCell,
    required this.docId,
    required this.qty,
    required this.count,
  });

  static final empty = Nom(
      name: '',
      article: '',
      barcode: '',
      nameCell: '',
      codeCell: '',
      docId: '',
      qty: 0,
      count: 0);
}
