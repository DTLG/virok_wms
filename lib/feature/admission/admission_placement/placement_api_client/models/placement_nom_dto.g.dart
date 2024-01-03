// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'placement_nom_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlacementNomsDTO _$PlacementNomsDTOFromJson(Map<String, dynamic> json) =>
    PlacementNomsDTO(
      noms: (json['noms'] as List<dynamic>)
          .map((e) => PlacementNomDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      errorMassage: json['ErrorMassage'] as String?,
    );

Map<String, dynamic> _$PlacementNomsDTOToJson(PlacementNomsDTO instance) =>
    <String, dynamic>{
      'noms': instance.noms,
      'ErrorMassage': instance.errorMassage,
    };

PlacementNomDTO _$PlacementNomDTOFromJson(Map<String, dynamic> json) =>
    PlacementNomDTO(
      name: json['mom'] as String?,
      article: json['article'] as String?,
      barcodes: (json['barcodes'] as List<dynamic>)
          .map((e) => BarcodeDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      allCount: (json['all_count'] as num?)?.toDouble(),
      freeCount: (json['free_count'] as num?)?.toDouble(),
      reservedCount: (json['reserved_count'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PlacementNomDTOToJson(PlacementNomDTO instance) =>
    <String, dynamic>{
      'mom': instance.name,
      'article': instance.article,
      'barcodes': instance.barcodes,
      'all_count': instance.allCount,
      'free_count': instance.freeCount,
      'reserved_count': instance.reservedCount,
    };
