import 'package:json_annotation/json_annotation.dart';

part 'return_nom_dto.g.dart';

@JsonSerializable(createPerFieldToJson: false)
class ReturnNomsDTO {
  @JsonKey(name: 'noms')
  final List<ReturnNomDTO> noms;
  final String? invoice;
  @JsonKey(name: 'ErrorMassage')
  final String? errorMassage;
  ReturnNomsDTO(
      {required this.noms, required this.errorMassage, required this.invoice});

  factory ReturnNomsDTO.fromJson(Map<String, dynamic> json) =>
      _$ReturnNomsDTOFromJson(json);
}

@JsonSerializable(createPerFieldToJson: false)
class ReturnNomDTO {
  final String? number;
  @JsonKey(name: 'tovar')
  final String? name;
  final String? article;
  final List<BarcodeDTO> barcodes;
  final double? qty;
  final double? count;
  @JsonKey(name: 'nom_status')
  final String? nomStatus;

  ReturnNomDTO(
      {required this.name,
      required this.article,
      required this.barcodes,
      required this.number,
      required this.qty,
      required this.count,
      required this.nomStatus});

  factory ReturnNomDTO.fromJson(Map<String, dynamic> json) =>
      _$ReturnNomDTOFromJson(json);
}

@JsonSerializable(createPerFieldToJson: false)
class BarcodeDTO {
  final String? barcode;
  final double? ratio;

  BarcodeDTO({required this.barcode, required this.ratio});

  factory BarcodeDTO.fromJson(Map<String, dynamic> json) =>
      _$BarcodeDTOFromJson(json);
}

@JsonSerializable(createPerFieldToJson: false)
class BascketDTO {
  final String? basket;
  final String? basketName;

  BascketDTO({required this.basket, required this.basketName});

  factory BascketDTO.fromJson(Map<String, dynamic> json) =>
      _$BascketDTOFromJson(json);
}

@JsonSerializable(createPerFieldToJson: false)
class CellDTO {
  @JsonKey(name: "code_cell")
  final String? codeCell;
  @JsonKey(name: "name_cell")
  final String? nameCell;

  CellDTO({required this.codeCell, required this.nameCell});

  factory CellDTO.fromJson(Map<String, dynamic> json) =>
      _$CellDTOFromJson(json);
}
