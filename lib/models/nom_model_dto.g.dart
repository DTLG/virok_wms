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


NomDTO _$NomDTOFromJson(Map<String, dynamic> json) => NomDTO(
      name: json['tovar'] as String?,
      table: json['table'] as String?,
      article: json['article'] as String?,
      barcodes: (json['barcodes'] as List<dynamic>)
          .map((e) => BarcodeDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      nameCell: json['name_cell'] as String?,
      codeCell: json['cod_cell'] as String?,
      cells: (json['available_cells'] as List<dynamic>?)
          ?.map((e) => CellDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      docNumber: json['DocNumber'] as String?,
      qty: (json['qty'] as num?)?.toDouble(),
      count: (json['count'] as num?)?.toDouble(),
      itsMyne: json['its_myne'] as int?,
      baskets: (json['baskets'] as List<dynamic>?)
          ?.map((e) => BascketDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );


BascketDTO _$BascketDTOFromJson(Map<String, dynamic> json) => BascketDTO(
      basket: json['basket'] as String?,
      basketName: json['basket_name'] as String?,
    );


CellDTO _$CellDTOFromJson(Map<String, dynamic> json) => CellDTO(
      codeCell: json['code_cell'] as String?,
      nameCell: json['name_cell'] as String?,
    );

