// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_cell_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckCellDTO _$CheckCellDTOFromJson(Map<String, dynamic> json) => CheckCellDTO(
      codCell: json['cod_cell'] as String?,
      nameCell: json['name_cell'] as String?,
      noms: (json['noms'] as List<dynamic>)
          .map((e) => NomDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
                errorMasssage: json['ErrorMassage'] as String?,

    );


NomDTO _$NomDTOFromJson(Map<String, dynamic> json) => NomDTO(
      name: json['name'] as String?,
      article: json['article'] as String?,
      qty: json['qty'] as int?,
      minRest: json['min_rest'] as int?,
      barcodes: (json['barcodes'] as List<dynamic>)
          .map((e) => BarcodeDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

