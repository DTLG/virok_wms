import '../../../../../models/barcode_model.dart';

class AdmissionNoms {
  final List<AdmissionNom> noms;
  final String errorMassage;

  AdmissionNoms({
    required this.noms,
        required this.errorMassage

  });

  static final empty = AdmissionNoms(noms: [], errorMassage: '');
}

class AdmissionNom {
  final String taskNumber;
  final String date;
  final String name;
  final double qty;
  final String article;
  final List<Barcode> barcodes;
  final double count;
  final String nameCell;
  final String codeCell;

  AdmissionNom(
      {required this.taskNumber,
      required this.date,
      required this.name,
      required this.qty,
      required this.article,
      required this.barcodes,
      required this.count,
      required this.codeCell,
      required this.nameCell});

  static final empty = AdmissionNom(
      taskNumber: '',
      date: '',
      name: '',
      qty: 0,
      article: '',
      barcodes: [],
      count: 0,
      codeCell: '',
      nameCell: '');
}
