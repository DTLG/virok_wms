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
    cells: (json['available_cells'] as List<dynamic>?)
        ?.map((e) => CellDTO.fromJson(e as Map<String, dynamic>))
        .toList(),
    docNumber: json['DocNumber'] as String?,
    qty: (json['qty'] as num?)?.toDouble(),
    count: (json['count'] as num?)?.toDouble(),
    itsMyne: double.tryParse((json['its_myne'] as int?)?.toString() ?? ''),
    baskets: (json['baskets'] as List<dynamic>?)
        ?.map((e) => BascketDTO.fromJson(e as Map<String, dynamic>))
        .toList(),
    taskNumber: json['task_number'] as String?,
    statusNom: json['status_nom'] as String?);

Map<String, dynamic> _$NomDTOToJson(NomDTO instance) => <String, dynamic>{
      'tovar': instance.name,
      'article': instance.article,
      'barcodes': instance.barcodes,
      'name_cell': instance.nameCell,
      'cod_cell': instance.codeCell,
      'available_cells': instance.cells,
      'DocNumber': instance.docNumber,
      'qty': instance.qty,
      'table': instance.table,
      'its_myne': instance.itsMyne,
      'baskets': instance.baskets,
      'task_number': instance.taskNumber,
      'count': instance.count,
    };

BascketDTO _$BascketDTOFromJson(Map<String, dynamic> json) => BascketDTO(
      basket: json['basket'] as String?,
      basketName: json['basket_name'] as String?,
    );

Map<String, dynamic> _$BascketDTOToJson(BascketDTO instance) =>
    <String, dynamic>{
      'basket': instance.basket,
      'basket_name': instance.basketName,
    };

CellDTO _$CellDTOFromJson(Map<String, dynamic> json) => CellDTO(
      codeCell: json['code_cell'] as String?,
      nameCell: json['name_cell'] as String?,
    );

Map<String, dynamic> _$CellDTOToJson(CellDTO instance) => <String, dynamic>{
      'code_cell': instance.codeCell,
      'name_cell': instance.nameCell,
    };
