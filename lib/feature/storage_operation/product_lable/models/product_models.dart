import 'package:equatable/equatable.dart';

class ProductLables extends Equatable {
  final List<ProductLable> labels;

  const ProductLables({required this.labels});

  factory ProductLables.fromJson(Map<String, dynamic> json) {
    return ProductLables(
        labels: (json['Labels'] as List<dynamic>)
            .map((e) => ProductLable.fromJson(e))
            .toList());
  }
  static const empty = ProductLables(labels: []);
  @override
  List<Object?> get props => [labels];
}

class ProductLable {
  final String name;

  final String text;

  ProductLable({required this.text, required this.name});

  factory ProductLable.fromJson(Map<String, dynamic> json) {
    return ProductLable(text: json['Text'] ?? '', name: json['Name'] ?? '');
  }
}
