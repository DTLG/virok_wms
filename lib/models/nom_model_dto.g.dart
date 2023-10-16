// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nom_model_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NomsDTO _$NomsDTOFromJson(Map<String, dynamic> json) => NomsDTO(
      noms: (json['noms'] as List<dynamic>)
          .map((e) => NomDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as int?,
    );

Map<String, dynamic> _$NomsDTOToJson(NomsDTO instance) => <String, dynamic>{
      'noms': instance.noms,
      'status': instance.status,
    };

NomDTO _$NomDTOFromJson(Map<String, dynamic> json) => NomDTO(
      name: json['tovar'] as String?,
      article: json['article'] as String?,
      barcode: json['barcode'] as String?,
      nameCell: json['name_cell'] as String?,
      codeCell: json['cod_cell'] as String?,
      docId: json['number'] as String?,
      qty: (json['qty'] as num?)?.toDouble(),
      count: (json['count'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$NomDTOToJson(NomDTO instance) => <String, dynamic>{
      'tovar': instance.name,
      'article': instance.article,
      'barcode': instance.barcode,
      'name_cell': instance.nameCell,
      'cod_cell': instance.codeCell,
      'number': instance.docId,
      'qty': instance.qty,
      'count': instance.count,
    };
