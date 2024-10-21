import 'package:json_annotation/json_annotation.dart';

part 'barcodes_noms.g.dart';

@JsonSerializable()
class BarcodesNomsDTO {
  final List<BarcodesNomDTO> noms;

  BarcodesNomsDTO({required this.noms});

  factory BarcodesNomsDTO.fromJson(Map<String, dynamic> json) =>
      _$BarcodesNomsDTOFromJson(json);
}

@JsonSerializable()
class BarcodesNomDTO {
  @JsonKey(name: "tovar")
  final String? name;
  final String? article;
  final List<BarcodeDTO> barcodes;

  factory BarcodesNomDTO.fromJson(Map<String, dynamic> json) =>
      _$BarcodesNomDTOFromJson(json);

  BarcodesNomDTO(
      {required this.name, required this.article, required this.barcodes});
}

@JsonSerializable()
class BarcodeDTO {
  final String? barcode;
  final int? count;
  final int? ratio;

  factory BarcodeDTO.fromJson(Map<String, dynamic> json) =>
      _$BarcodeDTOFromJson(json);

  BarcodeDTO({required this.barcode, required this.count, required this.ratio});
}
