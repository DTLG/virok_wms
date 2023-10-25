import 'package:json_annotation/json_annotation.dart';

part 'nom_model_dto.g.dart';

@JsonSerializable()
class NomsDTO {
  @JsonKey(name: 'noms')
  final List<NomDTO> noms;
  final int? status;

  NomsDTO({required this.noms, required this.status});

  factory NomsDTO.fromJson(Map<String, dynamic> json) =>
      _$NomsDTOFromJson(json);
}

@JsonSerializable()
class NomDTO {
  @JsonKey(name: 'tovar')
  final String? name;
  final String? article;
  final List<BarcodeDTO> barcodes;
  @JsonKey(name: 'name_cell')
  final String? nameCell;
  @JsonKey(name: 'cod_cell')
  final String? codeCell;
  @JsonKey(name: 'DocNumber')
  final String? docNumber;
  final double? qty;
  final String? table;
    @JsonKey(name: 'its_myne')

  final int? itsMyne;
  final List<BascketDTO>? baskets;


  final double? count;

  NomDTO({
    required this.name,
    required this.table,
    required this.article,
    required this.barcodes,
    required this.nameCell,
    required this.codeCell,
    required this.docNumber,
    required this.qty,
    required this.count,
    required this.itsMyne,
    required this.baskets
  });

  factory NomDTO.fromJson(Map<String, dynamic> json) => _$NomDTOFromJson(json);
}

@JsonSerializable()
class BarcodeDTO{
  final String? barcode;
  final int? ratio;

  BarcodeDTO({required this.barcode, required this.ratio});

    factory BarcodeDTO.fromJson(Map<String, dynamic> json) => _$BarcodeDTOFromJson(json);

}
@JsonSerializable()
class BascketDTO{
  final String? basket;
  final String? basketName;

  BascketDTO({required this.basket, required this.basketName});

    factory BascketDTO.fromJson(Map<String, dynamic> json) => _$BascketDTOFromJson(json);

}