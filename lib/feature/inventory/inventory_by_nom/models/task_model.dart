import 'package:json_annotation/json_annotation.dart';
import 'package:virok_wms/feature/inventory/inventory_by_nom/models/barcode_model.dart';

part 'task_model.g.dart';

@JsonSerializable(createToJson: false)
class InventoryByNomTasksModel {
  @JsonKey(name: 'docs')
  final List<InventoryByNomTaskModel> inventoryTasks;
  @JsonKey(name: 'ErrorMassage')
  final String? errorMassage;

  InventoryByNomTasksModel(
      {required this.inventoryTasks, required this.errorMassage});

  factory InventoryByNomTasksModel.fromJson(Map<String, dynamic> json) =>
      _$InventoryByNomTasksModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class InventoryByNomTaskModel {
  @JsonKey(name: 'doc_number')
  final String? docNumber;
  @JsonKey(name: 'doc_date')
  final String? date;
  @JsonKey(name: 'nom')
  final String? nom;
  @JsonKey(name: 'article')
  final String? article;
  final List<BarcodeModel> barcodes;

  InventoryByNomTaskModel(
      {required this.docNumber,
      required this.date,
      required this.nom,
      required this.article,
      required this.barcodes});

  factory InventoryByNomTaskModel.fromJson(Map<String, dynamic> json) =>
      _$InventoryByNomTaskModelFromJson(json);
}

