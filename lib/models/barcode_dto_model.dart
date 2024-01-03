import 'package:json_annotation/json_annotation.dart';

part 'barcode_dto_model.g.dart';

@JsonSerializable()
class BarcodeDTO {
  final String? barcode;
  final int? ratio;

  BarcodeDTO({required this.barcode, required this.ratio});

  factory BarcodeDTO.fromJson(Map<String, dynamic> json) =>
      _$BarcodeDTOFromJson(json);
}
