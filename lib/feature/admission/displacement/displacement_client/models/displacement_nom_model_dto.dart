import 'package:json_annotation/json_annotation.dart';

part 'displacement_nom_model_dto.g.dart';

@JsonSerializable()
class DisplacementNomsDTO {
  @JsonKey(name: 'noms')
  final List<DisplacementNomDTO> noms;
final String? invoice;
  @JsonKey(name: 'ErrorMassage')

final String? errorMassage;
  DisplacementNomsDTO({required this.noms, required this.errorMassage, required this.invoice});

  factory DisplacementNomsDTO.fromJson(Map<String, dynamic> json) =>
      _$DisplacementNomsDTOFromJson(json);
}

@JsonSerializable()
class DisplacementNomDTO {
  final String? number;
  @JsonKey(name: 'tovar')
  final String? name;
  final String? article;
  final List<BarcodeDTO> barcodes;
  final double? qty;
  final double? count;

  DisplacementNomDTO(
      {required this.name,
      required this.article,
      required this.barcodes,
      required this.number,

      required this.qty,
      required this.count,
});

  factory DisplacementNomDTO.fromJson(Map<String, dynamic> json) => _$DisplacementNomDTOFromJson(json);
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

