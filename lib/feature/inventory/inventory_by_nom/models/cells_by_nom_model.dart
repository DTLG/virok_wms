import 'package:json_annotation/json_annotation.dart';
import 'package:virok_wms/feature/inventory/inventory_by_nom/models/barcode_model.dart';

part 'cells_by_nom_model.g.dart';

@JsonSerializable(createToJson: false)
class CellsByNomModel {
  final String? nom;
  final String? article;
  final List<BarcodeModel>? barcodes;
  final List<Cell>? cells;
  @JsonKey(name: 'doc_number')
  final String? docNumber;
  @JsonKey(name: 'ErrorMassage')
  final String? errorMassage;

  CellsByNomModel(
      {required this.nom,
      required this.article,
      required this.barcodes,
      required this.cells,
      required this.docNumber,
      required this.errorMassage});
  factory CellsByNomModel.fromJson(Map<String, dynamic> json) =>
      _$CellsByNomModelFromJson(json);
}



@JsonSerializable(createToJson: false)
class Cell {
  @JsonKey(name: 'сell_code')
  final String? code;
  @JsonKey(name: 'сell_name')
  final String? name;
  @JsonKey(name: 'plan_count')
  final int? planCount;
  @JsonKey(name: 'fact_count')
  final int? factCount;
  @JsonKey(name: 'nom_status')
  final String? nomStatus;

  Cell(
      {required this.code,
      required this.name,
      required this.planCount,
      required this.factCount,
      required this.nomStatus});
  factory Cell.fromJson(Map<String, dynamic> json) => _$CellFromJson(json);
}
