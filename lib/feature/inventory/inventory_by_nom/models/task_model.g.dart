// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryByNomTasksModel _$InventoryByNomTasksModelFromJson(
        Map<String, dynamic> json) =>
    InventoryByNomTasksModel(
      inventoryTasks: (json['docs'] as List<dynamic>)
          .map((e) =>
              InventoryByNomTaskModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      errorMassage: json['ErrorMassage'] as String?,
    );

InventoryByNomTaskModel _$InventoryByNomTaskModelFromJson(
        Map<String, dynamic> json) =>
    InventoryByNomTaskModel(
      docNumber: json['doc_number'] as String?,
      date: json['doc_date'] as String?,
      nom: json['nom'] as String?,
      article: json['article'] as String?,
      barcodes: (json['barcodes'] as List<dynamic>)
          .map((e) => BarcodeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
