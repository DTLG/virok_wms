import 'package:json_annotation/json_annotation.dart';
import 'package:virok_wms/feature/inventory/inventory_by_nom/models/barcode_model.dart';

part 'nom_in_cell_model.g.dart';

@JsonSerializable(createToJson: false)
class InventoryNomInCellTasksModel {
  @JsonKey(name: "inventory_tasks")
  final List<InventoryNomInCellTaskModel>? tasks;
  @JsonKey(name: "ErrorMassage")
  final String? errorMassage;

  InventoryNomInCellTasksModel({
    required this.tasks,
    required this.errorMassage,
  });

  factory InventoryNomInCellTasksModel.fromJson(Map<String, dynamic> json) =>
      _$InventoryNomInCellTasksFromJson(json);
}

@JsonSerializable(createToJson: false)
class InventoryNomInCellTaskModel {
  @JsonKey(name: "nom")
  final String? nom;
  @JsonKey(name: "article")
  final String? article;
  @JsonKey(name: "barcodes")
  final List<BarcodeModel>? barcodes;
  @JsonKey(name: "task_number")
  final String? taskNumber;
  @JsonKey(name: "cod_cell")
  final String? codCell;
  @JsonKey(name: "name_cell")
  final String? nameCell;
  @JsonKey(name: "count")
  final int? count;
  @JsonKey(name: "scanned_count")
  final int? scannedCount;
  @JsonKey(name: "nom_status")
  final String? nomSatus;

  InventoryNomInCellTaskModel(
      {required this.nom,
      required this.article,
      required this.barcodes,
      required this.taskNumber,
      required this.codCell,
      required this.nameCell,
      required this.count,
      required this.scannedCount,
      required this.nomSatus});

  factory InventoryNomInCellTaskModel.fromJson(Map<String, dynamic> json) =>
      _$InventoryNomInCellTaskFromJson(json);
}
