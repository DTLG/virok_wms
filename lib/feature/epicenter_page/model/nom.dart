class Nom {
  final String tovar;
  final int countNeed;
  final String article;
  final List<Barcode> barcodes;
  final int countScanned;

  Nom({
    required this.tovar,
    required this.countNeed,
    required this.article,
    required this.barcodes,
    required this.countScanned,
  });

  // Фабричний метод для створення об'єкта з JSON
  factory Nom.fromJson(Map<String, dynamic> json) {
    return Nom(
      tovar: json['tovar'],
      countNeed: json['count_need'].truncate(),
      article: json['article'],
      barcodes: (json['barcodes'] as List)
          .map((barcode) => Barcode.fromJson(barcode))
          .toList(),
      countScanned: json['count_scanned'].truncate(),
    );
  }

  // Метод для конвертації об'єкта в JSON
  Map<String, dynamic> toJson() {
    return {
      'tovar': tovar,
      'count_need': countNeed,
      'article': article,
      'barcodes': barcodes.map((barcode) => barcode.toJson()).toList(),
      'count_scanned': countScanned,
    };
  }

  // Статичний метод empty для створення пустого Nom
  static final empty = Nom(
    tovar: '',
    countNeed: 0,
    article: '',
    barcodes: [],
    countScanned: 0,
  );
}

class Barcode {
  final String barcode;
  final int count;
  final int ratio;

  Barcode({
    required this.barcode,
    required this.count,
    required this.ratio,
  });

  factory Barcode.fromJson(Map<String, dynamic> json) {
    return Barcode(
      barcode: json['barcode'],
      count: json['count'].truncate(),
      ratio: json['ratio'].truncate(),
    );
  }

  // Метод для конвертації об'єкта в JSON
  Map<String, dynamic> toJson() {
    return {
      'barcode': barcode,
      'count': count,
      'ratio': ratio,
    };
  }

  // Статичний метод empty для створення пустого Barcode
  static final empty = Barcode(
    barcode: '',
    count: 0,
    ratio: 1, // Можна залишити дефолтне значення 1.0
  );
}
