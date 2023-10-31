// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basket_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BasketDataDTO _$BasketDataDTOFromJson(Map<String, dynamic> json) =>
    BasketDataDTO(
      docNumber: json['doc_number'] as String?,
      table: TableDTO.fromJson(json['table'] as Map<String, dynamic>),
      basket: json['basket'] as String?,
    );

Map<String, dynamic> _$BasketDataDTOToJson(BasketDataDTO instance) =>
    <String, dynamic>{
      'doc_number': instance.docNumber,
      'table': instance.table,
      'basket': instance.basket,
    };

TableDTO _$TableDTOFromJson(Map<String, dynamic> json) => TableDTO(
      name: json['name'] as String?,
      barcode: json['barcode'] as String?,
    );

Map<String, dynamic> _$TableDTOToJson(TableDTO instance) => <String, dynamic>{
      'name': instance.name,
      'barcode': instance.barcode,
    };
