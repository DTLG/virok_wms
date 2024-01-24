// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_doc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocsModel _$DocsModelFromJson(Map<String, dynamic> json) => DocsModel(
      docs: (json['docs'] as List<dynamic>)
          .map((e) => DocModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      errorMassage: json['ErrorMassage'] as String?,
    );

Map<String, dynamic> _$DocsModelToJson(DocsModel instance) => <String, dynamic>{
      'docs': instance.docs,
      'ErrorMassage': instance.errorMassage,
    };

DocModel _$DocModelFromJson(Map<String, dynamic> json) => DocModel(
      docNumber: json['doc_number'] as String?,
      docDate: json['doc_date'] as String?,
    );

Map<String, dynamic> _$DocModelToJson(DocModel instance) => <String, dynamic>{
      'doc_number': instance.docNumber,
      'doc_date': instance.docDate,
    };
