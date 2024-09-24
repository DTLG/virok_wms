// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_element

part of 'cell_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CellDTO _$CellDTOFromJson(Map<String, dynamic> json) => CellDTO(
      cell: (json['cell'] as List<dynamic>)
          .map((e) => CellData.fromJson(e as Map<String, dynamic>))
          .toList(),
      zone: json['zone'] as int?,
    );

Map<String, dynamic> _$CellDTOToJson(CellDTO instance) => <String, dynamic>{
      'cell': instance.cell,
      'zone': instance.zone,
    };

CellData _$CellDataFromJson(Map<String, dynamic> json) => CellData(
      nom: json['tovar'] as String?,
      quantity: json['qty'],
      nameCell: json['name_cell'] as String?,
      codeCell: json['code_cell'] as String?,
      article: json['article'] as String?,
      barcodes: (json['barcodes'] as List<dynamic>)
          .map((e) => BarcodeDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as double?,
    );

Map<String, dynamic> _$CellDataToJson(CellData instance) => <String, dynamic>{
      'tovar': instance.nom,
      'qty': instance.quantity,
      'name_cell': instance.nameCell,
      'code_cell': instance.codeCell,
      'barcodes': instance.barcodes,
      'article': instance.article,
      'status': instance.status,
    };

BarcodeDTO _$BarcodeDTOFromJson(Map<String, dynamic> json) => BarcodeDTO(
      barcode: json['barcode'] as String?,
      ratio: json['ratio'] as double?,
    );

Map<String, dynamic> _$BarcodeDTOToJson(BarcodeDTO instance) =>
    <String, dynamic>{
      'barcode': instance.barcode,
      'ratio': instance.ratio,
    };
