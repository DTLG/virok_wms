import 'package:json_annotation/json_annotation.dart';

part 'task_noms_models.g.dart';

@JsonSerializable(createToJson: false)
class CellInventoryTaskNomsModel {
  @JsonKey(name: "cell_inventory_task_data")
  final List<CellInventoryTaskNomModel> cellInventoryTaskData;
  @JsonKey(name: "ErrorMassage")
  final String? errorMassage;

  CellInventoryTaskNomsModel(
      {required this.cellInventoryTaskData, required this.errorMassage});

  factory CellInventoryTaskNomsModel.fromJson(Map<String, dynamic> json) =>
      _$CellInventoryTaskNomsModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class CellInventoryTaskNomModel {
  @JsonKey(name: "nom")
  final String? nom;
  @JsonKey(name: "article")
  final String? article;
  @JsonKey(name: "barcodes")
  final List<Barcode> barcodes;
  @JsonKey(name: "task_number")
  final String? taskNumber;
  @JsonKey(name: "cod_cell")
  final String? codCell;
  @JsonKey(name: "name_cell")
  final String? nameCell;
  @JsonKey(name: "count")
  final double? count;
  @JsonKey(name: "scanned_count")
  final double? scannedCount;
  @JsonKey(name: "nom_status")
  final String? nomStatus;

  CellInventoryTaskNomModel({
    required this.nom,
    required this.article,
    required this.barcodes,
    required this.taskNumber,
    required this.codCell,
    required this.nameCell,
    required this.count,
    required this.scannedCount,
    required this.nomStatus,
  });

  factory CellInventoryTaskNomModel.fromJson(Map<String, dynamic> json) =>
      _$CellInventoryTaskNomModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class Barcode {
  @JsonKey(name: "barcode")
  final String? barcode;
  @JsonKey(name: "count")
  final double? count;
  @JsonKey(name: "ratio")
  final double? ratio;

  Barcode({
    required this.barcode,
    required this.count,
    required this.ratio,
  });

  factory Barcode.fromJson(Map<String, dynamic> json) =>
      _$BarcodeFromJson(json);
}
