// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barcode_dto_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BarcodeDTO _$BarcodeDTOFromJson(Map<String, dynamic> json) => BarcodeDTO(
      barcode: json['barcode'] as String?,
      ratio: double.tryParse((json['ratio'] as double?)?.toString() ?? ''),
    );

Map<String, dynamic> _$BarcodeDTOToJson(BarcodeDTO instance) =>
    <String, dynamic>{
      'barcode': instance.barcode,
      'ratio': instance.ratio,
    };
