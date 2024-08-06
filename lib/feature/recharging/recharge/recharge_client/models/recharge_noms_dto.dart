import 'package:json_annotation/json_annotation.dart';
import 'package:virok_wms/models/barcode_dto_model.dart';

part 'recharge_noms_dto.g.dart';

@JsonSerializable()
class RechargeNomsDTO {
  final List<RechargeNomDTO> tasks;
  @JsonKey(name: 'ErrorMassage')
  final String? errorMassage;

  RechargeNomsDTO({
    required this.tasks,
    required this.errorMassage,
  });

  factory RechargeNomsDTO.fromJson(Map<String, dynamic> json) =>
      _$RechargeNomsDTOFromJson(json);
}

@JsonSerializable()
class RechargeNomDTO {
  @JsonKey(name: "task_number")
  final String? taskNumber;
  final String? date;
  final String? tovar;
  final double? qty;
  final String? article;
  final List<BarcodeDTO> barcodes;
  @JsonKey(name: "count_take")
  final int? countTake;
  @JsonKey(name: "count_put")
  final int? countPut;
  @JsonKey(name: "cod_cell_from")
  final String? codCellFrom;
  @JsonKey(name: "name_cell_from")
  final String? nameCellFrom;
  @JsonKey(name: "cod_cell_to")
  final String? codCellTo;
  @JsonKey(name: "name_cell_to")
  final String? nameCellTo;
  @JsonKey(name: "is_started")
  final double? isStarted;

  RechargeNomDTO({
    required this.taskNumber,
    required this.date,
    required this.tovar,
    required this.qty,
    required this.article,
    required this.barcodes,
    required this.countTake,
    required this.countPut,
    required this.codCellFrom,
    required this.nameCellFrom,
    required this.codCellTo,
    required this.nameCellTo,
    required this.isStarted,
  });

  factory RechargeNomDTO.fromJson(Map<String, dynamic> json) =>
      _$RechargeNomDTOFromJson(json);
}
