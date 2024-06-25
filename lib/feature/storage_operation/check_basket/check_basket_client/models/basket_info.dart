class BasketsData {
  final List<BasketData> baskets;

  factory BasketsData.fromJson(Map<String, dynamic> json) => BasketsData(
      baskets: ((json['Baskets'] ?? []) as List<dynamic>)
          .map((e) => BasketData.fromJson(e))
          .toList());

  BasketsData({required this.baskets});

  static final empty = BasketsData(baskets: []);
}
enum BasketType { basket, cart }



class BasketData {
  String docNumber;
  Table table;
  String name;
  String barcode;

  BasketData(
      {required this.docNumber,
      required this.table,
      required this.name,
      required this.barcode});

  factory BasketData.fromJson(Map<String, dynamic> json) => BasketData(
      docNumber: json['doc_number'] ?? '',
      table: Table.fromJson((json['table'] ?? <String,dynamic>{}) as Map<String, dynamic>),
      name: json['Name' ] ?? '',
      barcode: json['Barcode'] ?? '');

  static final empty =
      BasketData(docNumber: '', table: Table.empty, name: '', barcode: '');
}

class Table {
  String name;
  String barcode;

  Table({required this.name, required this.barcode});
  factory Table.fromJson(Map<String, dynamic> json) => Table(
        name: json['name'] ?? '',
        barcode: json['barcode'] ?? '',
      );
  static final empty = Table(name: '', barcode: '');
}
