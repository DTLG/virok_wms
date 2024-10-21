// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_element

part of 'barcodes_noms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BarcodesNomsDTO _$BarcodesNomsDTOFromJson(Map<String, dynamic> json) =>
    BarcodesNomsDTO(
      noms: (json['noms'] as List<dynamic>)
          .map((e) => BarcodesNomDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BarcodesNomsDTOToJson(BarcodesNomsDTO instance) =>
    <String, dynamic>{
      'noms': instance.noms,
    };

BarcodesNomDTO _$BarcodesNomDTOFromJson(Map<String, dynamic> json) =>
    BarcodesNomDTO(
      name: json['tovar'] as String?,
      article: json['article'] as String?,
      barcodes: (json['barcodes'] as List<dynamic>)
          .map((e) => BarcodeDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BarcodesNomDTOToJson(BarcodesNomDTO instance) =>
    <String, dynamic>{
      'tovar': instance.name,
      'article': instance.article,
      'barcodes': instance.barcodes,
    };

BarcodeDTO _$BarcodeDTOFromJson(Map<String, dynamic> json) => BarcodeDTO(
      barcode: json['barcode'] as String?,
      count: json['count'] as int?,
      ratio: json['ratio'] as int?,
    );

Map<String, dynamic> _$BarcodeDTOToJson(BarcodeDTO instance) =>
    <String, dynamic>{
      'barcode': instance.barcode,
      'count': instance.count,
      'ratio': instance.ratio,
    };
