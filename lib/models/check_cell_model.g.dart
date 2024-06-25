// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_element

part of 'check_cell_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckCellDTO _$CheckCellDTOFromJson(Map<String, dynamic> json) => CheckCellDTO(
      codCell: json['cod_cell'] as String?,
      nameCell: json['name_cell'] as String?,
      noms: (json['noms'] as List<dynamic>)
          .map((e) => NomDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      errorMasssage: json['ErrorMassage'] as String?,
    );

Map<String, dynamic> _$CheckCellDTOToJson(CheckCellDTO instance) =>
    <String, dynamic>{
      'cod_cell': instance.codCell,
      'name_cell': instance.nameCell,
      'noms': instance.noms,
      'ErrorMassage': instance.errorMasssage,
    };

NomDTO _$NomDTOFromJson(Map<String, dynamic> json) => NomDTO(
      name: json['name'] as String?,
      article: json['article'] as String?,
      qty: json['qty'] as int?,
      minRest: json['min_rest'] as int?,
      barcodes: (json['barcodes'] as List<dynamic>)
          .map((e) => BarcodeDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NomDTOToJson(NomDTO instance) => <String, dynamic>{
      'name': instance.name,
      'article': instance.article,
      'qty': instance.qty,
      'min_rest': instance.minRest,
      'barcodes': instance.barcodes,
    };
