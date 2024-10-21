import 'package:json_annotation/json_annotation.dart';

part 'moving_in_nom_model_dto.g.dart';

@JsonSerializable()
class MovingInNomsDTO {
  @JsonKey(name: 'noms')
  final List<MovingInNomDTO> noms;
  final String? invoice;
  @JsonKey(name: 'ErrorMassage')
  final String? errorMassage;
  MovingInNomsDTO(
      {required this.noms, required this.errorMassage, required this.invoice});

  factory MovingInNomsDTO.fromJson(Map<String, dynamic> json) =>
      _$MovingInNomsDTOFromJson(json);
}

@JsonSerializable()
class MovingInNomDTO {
  final String? number;
  @JsonKey(name: 'tovar')
  final String? name;
  final String? article;
  final List<BarcodeDTO> barcodes;
  final int? qty;
  final int? count;

  MovingInNomDTO({
    required this.name,
    required this.article,
    required this.barcodes,
    required this.number,
    required this.qty,
    required this.count,
  });

  factory MovingInNomDTO.fromJson(Map<String, dynamic> json) =>
      _$MovingInNomDTOFromJson(json);
}

@JsonSerializable()
class BarcodeDTO {
  final String? barcode;
  final int? ratio;

  BarcodeDTO({required this.barcode, required this.ratio});

  factory BarcodeDTO.fromJson(Map<String, dynamic> json) =>
      _$BarcodeDTOFromJson(json);
}

@JsonSerializable()
class BascketDTO {
  final String? basket;
  final String? basketName;

  BascketDTO({required this.basket, required this.basketName});

  factory BascketDTO.fromJson(Map<String, dynamic> json) =>
      _$BascketDTOFromJson(json);
}

@JsonSerializable()
class CellDTO {
  @JsonKey(name: "code_cell")
  final String? codeCell;
  @JsonKey(name: "name_cell")
  final String? nameCell;

  CellDTO({required this.codeCell, required this.nameCell});

  factory CellDTO.fromJson(Map<String, dynamic> json) =>
      _$CellDTOFromJson(json);
}
