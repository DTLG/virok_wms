// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cells_by_nom_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CellsByNomModel _$CellsByNomModelFromJson(Map<String, dynamic> json) =>
    CellsByNomModel(
      nom: json['nom'] as String?,
      article: json['article'] as String?,
      barcodes: (json['barcodes'] as List<dynamic>?)
          ?.map((e) => BarcodeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      cells: (json['cells'] as List<dynamic>?)
          ?.map((e) => Cell.fromJson(e as Map<String, dynamic>))
          .toList(),
      docNumber: json['doc_number'] as String?,
      errorMassage: json['ErrorMassage'] as String?,
    );

Cell _$CellFromJson(Map<String, dynamic> json) => Cell(
      code: json['сell_code'] as String?,
      name: json['сell_name'] as String?,
      planCount: json['plan_count'] as int?,
      factCount: json['fact_count'] as int?,
      nomStatus: json['nom_status'] as String?,
    );
