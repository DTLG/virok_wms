import 'package:equatable/equatable.dart';

class ReturnEpicNoms extends Equatable {
  final List<ReturnEpicNom> noms;
  final String errorMassage;

  const ReturnEpicNoms({required this.noms, required this.errorMassage});

  factory ReturnEpicNoms.fromJson(Map<String, dynamic> json) {
    var list = json['noms'] as List;
    List<ReturnEpicNom> nomList =
        list.map((i) => ReturnEpicNom.fromJson(i)).toList();

    return ReturnEpicNoms(
      noms: nomList,
      errorMassage: json['ErrorMassage'],
    );
  }

  static const empty = ReturnEpicNoms(noms: [], errorMassage: '');

  @override
  List<Object?> get props => [noms, errorMassage];
}

class ReturnEpicNom extends Equatable {
  final String number;
  final String tovar;
  final int qty;
  final String article;
  final List<Barcode> barcodes;
  final int count;
  final String nomStatus;
  final String incomingInvoiceNumber;

  const ReturnEpicNom({
    required this.number,
    required this.tovar,
    required this.qty,
    required this.article,
    required this.barcodes,
    required this.count,
    required this.nomStatus,
    required this.incomingInvoiceNumber,
  });

  factory ReturnEpicNom.fromJson(Map<String, dynamic> json) {
    var list = json['barcodes'] as List;
    List<Barcode> barcodeList = list.map((i) => Barcode.fromJson(i)).toList();

    return ReturnEpicNom(
      number: json['number'],
      tovar: json['tovar'],
      qty: json['qty'],
      article: json['article'],
      barcodes: barcodeList,
      count: json['count'],
      nomStatus: json['nom_status'],
      incomingInvoiceNumber: json['incomingInvoice_number'],
    );
  }
  static const empty = ReturnEpicNom(
    number: '',
    tovar: '',
    qty: 0,
    article: '',
    barcodes: [],
    count: 0,
    nomStatus: '',
    incomingInvoiceNumber: '',
  );

  @override
  List<Object?> get props => [
        number,
        tovar,
        qty,
        article,
        barcodes,
        count,
        nomStatus,
        incomingInvoiceNumber
      ];
}

class Barcode {
  String barcode;
  int count;
  int ratio;

  Barcode({
    required this.barcode,
    required this.count,
    required this.ratio,
  });

  factory Barcode.fromJson(Map<String, dynamic> json) {
    return Barcode(
      barcode: json['barcode'],
      count: json['count'],
      ratio: json['ratio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'barcode': barcode,
      'count': count,
      'ratio': ratio,
    };
  }
}
