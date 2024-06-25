// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_noms_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CellInventoryTaskNomsModel _$CellInventoryTaskNomsModelFromJson(
        Map<String, dynamic> json) =>
    CellInventoryTaskNomsModel(
      cellInventoryTaskData: (json['cell_inventory_task_data'] as List<dynamic>)
          .map((e) =>
              CellInventoryTaskNomModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      errorMassage: json['ErrorMassage'] as String?,
    );

CellInventoryTaskNomModel _$CellInventoryTaskNomModelFromJson(
        Map<String, dynamic> json) =>
    CellInventoryTaskNomModel(
      nom: json['nom'] as String?,
      article: json['article'] as String?,
      barcodes: (json['barcodes'] as List<dynamic>)
          .map((e) => Barcode.fromJson(e as Map<String, dynamic>))
          .toList(),
      taskNumber: json['task_number'] as String?,
      codCell: json['cod_cell'] as String?,
      nameCell: json['name_cell'] as String?,
      count: json['count'] as int?,
      scannedCount: json['scanned_count'] as int?,
      nomStatus: json['nom_status'] as String?,
    );

Barcode _$BarcodeFromJson(Map<String, dynamic> json) => Barcode(
      barcode: json['barcode'] as String?,
      count: json['count'] as int?,
      ratio: json['ratio'] as int?,
    );
