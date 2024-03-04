// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nom_in_cell_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryNomInCellTasksModel _$InventoryNomInCellTasksFromJson(
        Map<String, dynamic> json) =>
    InventoryNomInCellTasksModel(
      tasks: (json['inventory_tasks'] as List<dynamic>?)
          ?.map(
              (e) => InventoryNomInCellTaskModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      errorMassage: json['ErrorMassage'] as String?,
    );

InventoryNomInCellTaskModel _$InventoryNomInCellTaskFromJson(
        Map<String, dynamic> json) =>
    InventoryNomInCellTaskModel(
      nom: json['nom'] as String?,
      article: json['article'] as String?,
      barcodes: (json['barcodes'] as List<dynamic>?)
          ?.map((e) => BarcodeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
          nomSatus: json['nom_status'] as String?,
      taskNumber: json['task_number'] as String?,
      codCell: json['cod_cell'] as String?,
      nameCell: json['name_cell'] as String?,
      count: json['count'] as int?,
      scannedCount: json['scanned_count'] as int?,
    );
