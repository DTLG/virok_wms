class Docs {
  final List<Doc> docs;
  final String errorMassage;

  Docs({required this.docs, required this.errorMassage});

  static final empty = Docs(docs: [], errorMassage: '');
}

class Doc {
  final String docNumber;
  final String docDate;

  Doc({required this.docNumber, required this.docDate});
}
