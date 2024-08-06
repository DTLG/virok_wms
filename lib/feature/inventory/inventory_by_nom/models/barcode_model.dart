import 'package:json_annotation/json_annotation.dart';

part 'barcode_model.g.dart';

@JsonSerializable(createToJson: false)
class BarcodeModel {
  @JsonKey(name: "barcode")
  final String? barcode;
  @JsonKey(name: "count")
  final double? count;
  @JsonKey(name: "ratio")
  final double? ratio;

  BarcodeModel({
    required this.barcode,
    required this.count,
    required this.ratio,
  });

  factory BarcodeModel.fromJson(Map<String, dynamic> json) =>
      _$BarcodeModelFromJson(json);
}
