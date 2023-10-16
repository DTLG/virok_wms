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
  final String? barcode;
    @JsonKey(name: 'name_cell')

  final String? nameCell;
  @JsonKey(name: 'cod_cell')
  final String? codeCell;
  @JsonKey(name: 'number')
  final String? docId;
  final double? qty;

  final double? count;

  NomDTO({
    required this.name,
    required this.article,
    required this.barcode,
    required this.nameCell,
    required this.codeCell,
    required this.docId,
    required this.qty,
    required this.count,
  });

  factory NomDTO.fromJson(Map<String, dynamic> json) => _$NomDTOFromJson(json);
}
