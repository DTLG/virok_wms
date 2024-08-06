import 'package:json_annotation/json_annotation.dart';
import 'package:virok_wms/models/barcode_dto_model.dart';

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
  @JsonKey(name: 'available_cells')
  final List<CellDTO>? cells;
  @JsonKey(name: 'DocNumber')
  final String? docNumber;
  final double? qty;
  final String? table;
  @JsonKey(name: 'its_myne')
  final double? itsMyne;
  final List<BascketDTO>? baskets;
  @JsonKey(name: 'task_number')
  final String? taskNumber;
  final double? count;
  @JsonKey(name: 'status_nom')
  final String? statusNom;

  NomDTO(
      {required this.name,
      required this.table,
      required this.article,
      required this.barcodes,
      required this.nameCell,
      required this.codeCell,
      required this.cells,
      required this.docNumber,
      required this.qty,
      required this.count,
      required this.itsMyne,
      required this.baskets,
      required this.taskNumber,
      required this.statusNom});

  factory NomDTO.fromJson(Map<String, dynamic> json) => _$NomDTOFromJson(json);
}

@JsonSerializable()
class BascketDTO {
  final String? basket;
  @JsonKey(name: 'basket_name')
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
