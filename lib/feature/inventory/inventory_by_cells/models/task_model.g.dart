// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryByCellsTasksModel _$InventoryByCellsTasksModelFromJson(
        Map<String, dynamic> json) =>
    InventoryByCellsTasksModel(
      inventoryTasks: (json['inventory_tasks'] as List<dynamic>)
          .map((e) =>
              InventoryByCellsTaskModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      errorMassage: json['ErrorMassage'] as String?,
    );

InventoryByCellsTaskModel _$InventoryByCellsTaskModelFromJson(
        Map<String, dynamic> json) =>
    InventoryByCellsTaskModel(
      taskNumber: json['task_number'] as String?,
      codeCell: json['cod_cell'] as String?,
      nameCell: json['name_cell'] as String?,
    );
