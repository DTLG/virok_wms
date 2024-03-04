// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_element

part of 'displacement_nom_model_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DisplacementNomsDTO _$DisplacementNomsDTOFromJson(Map<String, dynamic> json) =>
    DisplacementNomsDTO(
      noms: (json['noms'] as List<dynamic>)
          .map((e) => DisplacementNomDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      errorMassage: json['ErrorMassage'] as String?,
      invoice: json['invoice'] as String?,
    );

Map<String, dynamic> _$DisplacementNomsDTOToJson(
        DisplacementNomsDTO instance) =>
    <String, dynamic>{
      'noms': instance.noms,
      'invoice': instance.invoice,
      'ErrorMassage': instance.errorMassage,
    };

DisplacementNomDTO _$DisplacementNomDTOFromJson(Map<String, dynamic> json) =>
    DisplacementNomDTO(
      name: json['tovar'] as String?,
      article: json['article'] as String?,
      barcodes: (json['barcodes'] as List<dynamic>?)
          ?.map((e) => BarcodeDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      number: json['number'] as String?,
      qty: (json['qty'] as num?)?.toDouble(),
      count: (json['count'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DisplacementNomDTOToJson(DisplacementNomDTO instance) =>
    <String, dynamic>{
      'number': instance.number,
      'tovar': instance.name,
      'article': instance.article,
      'barcodes': instance.barcodes,
      'qty': instance.qty,
      'count': instance.count,
    };

BarcodeDTO _$BarcodeDTOFromJson(Map<String, dynamic> json) => BarcodeDTO(
      barcode: json['barcode'] as String?,
      ratio: json['ratio'] as int?,
    );

Map<String, dynamic> _$BarcodeDTOToJson(BarcodeDTO instance) =>
    <String, dynamic>{
      'barcode': instance.barcode,
      'ratio': instance.ratio,
    };

BascketDTO _$BascketDTOFromJson(Map<String, dynamic> json) => BascketDTO(
      basket: json['basket'] as String?,
      basketName: json['basketName'] as String?,
    );

Map<String, dynamic> _$BascketDTOToJson(BascketDTO instance) =>
    <String, dynamic>{
      'basket': instance.basket,
      'basketName': instance.basketName,
    };

CellDTO _$CellDTOFromJson(Map<String, dynamic> json) => CellDTO(
      codeCell: json['code_cell'] as String?,
      nameCell: json['name_cell'] as String?,
    );

Map<String, dynamic> _$CellDTOToJson(CellDTO instance) => <String, dynamic>{
      'code_cell': instance.codeCell,
      'name_cell': instance.nameCell,
    };
