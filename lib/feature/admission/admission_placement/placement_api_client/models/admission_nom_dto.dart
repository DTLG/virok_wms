import 'package:json_annotation/json_annotation.dart';
import 'package:virok_wms/models/barcode_dto_model.dart';

part 'admission_nom_dto.g.dart';

@JsonSerializable()
class AdmissionNomsDTO {
  final List<AdmissionNomDTO> noms;

  AdmissionNomsDTO({
    required this.noms,
  });

  factory AdmissionNomsDTO.fromJson(Map<String, dynamic> json) =>
      _$AdmissionNomsDTOFromJson(json);

}

@JsonSerializable()
class AdmissionNomDTO {
  @JsonKey(name: "task_number")
  final String? taskNumber;
  final String? date;

  @JsonKey(name: "tovar")
  final String? name;
  final double? qty;
  final String? article;
  final List<BarcodeDTO> barcodes;
  final double? count;
  @JsonKey(name: "name_cell")
  final String? nameCell;
  @JsonKey(name: "cod_cell")
  final String? codeCell;

  AdmissionNomDTO(
      {required this.taskNumber,
      required this.date,
      required this.name,
      required this.qty,
      required this.article,
      required this.barcodes,
      required this.count,
      required this.codeCell,
      required this.nameCell});

  factory AdmissionNomDTO.fromJson(Map<String, dynamic> json) =>
      _$AdmissionNomDTOFromJson(json);
}
