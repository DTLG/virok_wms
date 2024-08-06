class Barcode {
  final String barcode;
  final double ratio;

  Barcode({required this.barcode, required this.ratio});

  static final empty = Barcode(barcode: '', ratio: 0);
}
