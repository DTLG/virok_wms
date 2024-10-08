import 'package:json_annotation/json_annotation.dart';

part 'cell_models.g.dart';

@JsonSerializable()
class CellDTO {
  final List<CellData> cell;
  final int? zone;

  CellDTO({required this.cell, required this.zone});

  factory CellDTO.fromJson(Map<String, dynamic> json) =>
      _$CellDTOFromJson(json);
}

@JsonSerializable()
class CellData {
  @JsonKey(name: 'tovar')
  final String? nom;
  @JsonKey(name: 'qty')
  final dynamic quantity;
  @JsonKey(name: 'name_cell')
  final String? nameCell;
  @JsonKey(name: 'code_cell')
  final String? codeCell;
  final List<BarcodeDTO> barcodes;
  final String? article;

  final int? status;

  CellData(
      {required this.nom,
      required this.quantity,
      required this.nameCell,
      required this.codeCell,
      required this.article,
      required this.barcodes,
      required this.status});

  factory CellData.fromJson(Map<String, dynamic> json) =>
      _$CellDataFromJson(json);
}

@JsonSerializable()
class BarcodeDTO {
  final String? barcode;
  final int? ratio;

  BarcodeDTO({required this.barcode, required this.ratio});

  factory BarcodeDTO.fromJson(Map<String, dynamic> json) =>
      _$BarcodeDTOFromJson(json);
}
