// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admission_nom_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdmissionNomsDTO _$AdmissionNomsDTOFromJson(Map<String, dynamic> json) =>
    AdmissionNomsDTO(
      noms: (json['noms'] as List<dynamic>)
          .map((e) => AdmissionNomDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AdmissionNomsDTOToJson(AdmissionNomsDTO instance) =>
    <String, dynamic>{
      'noms': instance.noms,
    };

AdmissionNomDTO _$AdmissionNomDTOFromJson(Map<String, dynamic> json) =>
    AdmissionNomDTO(
      taskNumber: json['task_number'] as String?,
      date: json['date'] as String?,
      name: json['tovar'] as String?,
      qty: (json['qty'] as num?)?.toDouble(),
      article: json['article'] as String?,
      barcodes: (json['barcodes'] as List<dynamic>)
          .map((e) => BarcodeDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: (json['count'] as num?)?.toDouble(),
      codeCell: json['cod_cell'] as String?,
      nameCell: json['name_cell'] as String?,
    );

Map<String, dynamic> _$AdmissionNomDTOToJson(AdmissionNomDTO instance) =>
    <String, dynamic>{
      'task_number': instance.taskNumber,
      'date': instance.date,
      'tovar': instance.name,
      'qty': instance.qty,
      'article': instance.article,
      'barcodes': instance.barcodes,
      'count': instance.count,
      'name_cell': instance.nameCell,
      'cod_cell': instance.codeCell,
    };
