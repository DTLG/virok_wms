// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'return_nom_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReturnNomsDTO _$ReturnNomsDTOFromJson(Map<String, dynamic> json) =>
    ReturnNomsDTO(
      noms: (json['noms'] as List<dynamic>)
          .map((e) => ReturnNomDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      errorMassage: json['ErrorMassage'] as String?,
      invoice: json['invoice'] as String?,
    );

Map<String, dynamic> _$ReturnNomsDTOToJson(ReturnNomsDTO instance) =>
    <String, dynamic>{
      'noms': instance.noms,
      'invoice': instance.invoice,
      'ErrorMassage': instance.errorMassage,
    };

ReturnNomDTO _$ReturnNomDTOFromJson(Map<String, dynamic> json) => ReturnNomDTO(
      name: json['tovar'] as String?,
      article: json['article'] as String?,
      barcodes: (json['barcodes'] as List<dynamic>)
          .map((e) => BarcodeDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      number: json['number'] as String?,
      qty: (json['qty'] as num?)?.toDouble(),
      count: (json['count'] as num?)?.toDouble(),
      nomStatus: json['nom_status'] as String?,
    );

Map<String, dynamic> _$ReturnNomDTOToJson(ReturnNomDTO instance) =>
    <String, dynamic>{
      'number': instance.number,
      'tovar': instance.name,
      'article': instance.article,
      'barcodes': instance.barcodes,
      'qty': instance.qty,
      'count': instance.count,
      'nom_status': instance.nomStatus,
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
