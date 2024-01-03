import 'package:json_annotation/json_annotation.dart';

part 'barcodes_noms.g.dart';


@JsonSerializable()
class BarcodesNomsDTO{
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
  final List<CellDTO> cells;


  factory BarcodesNomDTO.fromJson(Map<String, dynamic> json) =>
      _$BarcodesNomDTOFromJson(json);

  BarcodesNomDTO(
      {required this.name, required this.article, required this.barcodes, required this.cells});
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

@JsonSerializable()
class CellDTO {
    @JsonKey(name: "code_cell")

  final String? codeCell;
  @JsonKey(name: "name_cell")
  final String? nameCell;
  final double? count;

  CellDTO({required this.codeCell, required this.nameCell, required this.count});

  factory CellDTO.fromJson(Map<String, dynamic> json) =>
      _$CellDTOFromJson(json);
}
