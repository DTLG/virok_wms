class Document {
  final String number;
  final String date;
  final String customer;
  final String guid;

  Document({
    required this.number,
    required this.date,
    required this.customer,
    required this.guid,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      number: json['number'],
      date: json['date'],
      customer: json['customer'],
      guid: json['guid'],
    );
  }
}
