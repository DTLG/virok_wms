// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryModel _$InventoryModelFromJson(Map<String, dynamic> json) =>
    InventoryModel(
      nom: json['nom'] as String?,
      article: json['article'] as String?,
      barcodes: (json['barcodes'] as List<dynamic>?)
          ?.map((e) => Barcode.fromJson(e as Map<String, dynamic>))
          .toList(),
      cells: (json['cells'] as List<dynamic>?)
          ?.map((e) => Cell.fromJson(e as Map<String, dynamic>))
          .toList(),
      docNumber: json['doc_number'] as String?,
      errorMassage: json['ErrorMassage'] as String?,
    );

Map<String, dynamic> _$InventoryModelToJson(InventoryModel instance) =>
    <String, dynamic>{
      'nom': instance.nom,
      'article': instance.article,
      'barcodes': instance.barcodes,
      'cells': instance.cells,
      'doc_number': instance.docNumber,
      'ErrorMassage': instance.errorMassage,
    };

Barcode _$BarcodeFromJson(Map<String, dynamic> json) => Barcode(
      barcode: json['barcode'] as String?,
      count: json['count'] as int?,
      ratio: json['ratio'] as int?,
    );

Map<String, dynamic> _$BarcodeToJson(Barcode instance) => <String, dynamic>{
      'barcode': instance.barcode,
      'count': instance.count,
      'ratio': instance.ratio,
    };

Cell _$CellFromJson(Map<String, dynamic> json) => Cell(
      cellCode: json['сell_code'] as String?,
      cellName: json['сell_name'] as String?,
      planCount: json['plan_count'] as int?,
      factCount: json['fact_count'] as int?,
      nomStatus: json['nom_status'] as String?,
    );

Map<String, dynamic> _$CellToJson(Cell instance) => <String, dynamic>{
      'сell_code': instance.cellCode,
      'сell_name': instance.cellName,
      'plan_count': instance.planCount,
      'fact_count': instance.factCount,
      'nom_status': instance.nomStatus,
    };
