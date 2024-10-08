// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recharge_noms_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RechargeNomsDTO _$RechargeNomsDTOFromJson(Map<String, dynamic> json) =>
    RechargeNomsDTO(
      tasks: (json['tasks'] as List<dynamic>)
          .map((e) => RechargeNomDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      errorMassage: json['ErrorMassage'] as String?,
    );

Map<String, dynamic> _$RechargeNomsDTOToJson(RechargeNomsDTO instance) =>
    <String, dynamic>{
      'tasks': instance.tasks,
      'ErrorMassage': instance.errorMassage,
    };

RechargeNomDTO _$RechargeNomDTOFromJson(Map<String, dynamic> json) =>
    RechargeNomDTO(
      taskNumber: json['task_number'] as String?,
      date: json['date'] as String?,
      tovar: json['tovar'] as String?,
      qty: json['qty'] as int?,
      article: json['article'] as String?,
      barcodes: (json['barcodes'] as List<dynamic>)
          .map((e) => BarcodeDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      countTake: json['count_take'] as int?,
      countPut: json['count_put'] as int?,
      codCellFrom: json['cod_cell_from'] as String?,
      nameCellFrom: json['name_cell_from'] as String?,
      codCellTo: json['cod_cell_to'] as String?,
      nameCellTo: json['name_cell_to'] as String?,
      isStarted: (json['is_started'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$RechargeNomDTOToJson(RechargeNomDTO instance) =>
    <String, dynamic>{
      'task_number': instance.taskNumber,
      'date': instance.date,
      'tovar': instance.tovar,
      'qty': instance.qty,
      'article': instance.article,
      'barcodes': instance.barcodes,
      'count_take': instance.countTake,
      'count_put': instance.countPut,
      'cod_cell_from': instance.codCellFrom,
      'name_cell_from': instance.nameCellFrom,
      'cod_cell_to': instance.codCellTo,
      'name_cell_to': instance.nameCellTo,
      'is_started': instance.isStarted,
    };
