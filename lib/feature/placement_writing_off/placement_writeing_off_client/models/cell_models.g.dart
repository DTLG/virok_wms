// GENERATED CODE - DO NOT MODIFY BY HAND

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
      barcode: (json['barcode'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList(),
      status: json['status'] as int?,
    );

Map<String, dynamic> _$CellDataToJson(CellData instance) => <String, dynamic>{
      'tovar': instance.nom,
      'qty': instance.quantity,
      'name_cell': instance.nameCell,
      'code_cell': instance.codeCell,
      'barcode': instance.barcode,
      'article': instance.article,
      'status': instance.status,
    };
