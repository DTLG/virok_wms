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
      table: json['table'] as String?,
      article: json['article'] as String?,
      barcodes: (json['barcodes'] as List<dynamic>)
          .map((e) => BarcodeDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      nameCell: json['name_cell'] as String?,
      codeCell: json['cod_cell'] as String?,
      docNumber: json['DocNumber'] as String?,
      qty: (json['qty'] as num?)?.toDouble(),
      count: (json['count'] as num?)?.toDouble(),
      itsMyne: json['its_myne'] as int?,
      baskets: (json['baskets'] as List<dynamic>?)
          ?.map((e) => BascketDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NomDTOToJson(NomDTO instance) => <String, dynamic>{
      'tovar': instance.name,
      'article': instance.article,
      'barcodes': instance.barcodes,
      'name_cell': instance.nameCell,
      'cod_cell': instance.codeCell,
      'DocNumber': instance.docNumber,
      'qty': instance.qty,
      'table': instance.table,
      'its_myne': instance.itsMyne,
      'baskets': instance.baskets,
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
      basketName: json['basket_name'] as String?,
    );

Map<String, dynamic> _$BascketDTOToJson(BascketDTO instance) =>
    <String, dynamic>{
      'bascket': instance.basket,
      'bascetName': instance.basketName,
    };
