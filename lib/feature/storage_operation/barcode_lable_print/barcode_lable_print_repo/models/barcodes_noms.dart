import 'package:equatable/equatable.dart';

class BarcodesNoms extends Equatable {
  final List<BarcodesNom> noms;

  const BarcodesNoms({required this.noms});

  @override
  List<Object?> get props => [noms];

  static const empty = BarcodesNoms(noms: []);
}

class BarcodesNom extends Equatable {
  final String name;
  final String article;
  final List<Barcode> barodes;

  const BarcodesNom(
      {required this.name, required this.article, required this.barodes});

  @override
  List<Object?> get props => [name, article, barodes];

  static const empty = BarcodesNom(name: '', article: '', barodes: []);
}

class Barcode extends Equatable {
  final String barcode;
  final int count;
  final int ratio;

  const Barcode(
      {required this.barcode, required this.count, required this.ratio});

  @override
  List<Object?> get props => [barcode, count, ratio];
}
