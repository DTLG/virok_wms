import 'package:json_annotation/json_annotation.dart';
import 'package:virok_wms/feature/moving/moving_in/moving_in_client/models/moving_in_nom_model_dto.dart';

part 'check_cell_model.g.dart';

@JsonSerializable()
class CheckCellDTO {
  @JsonKey(name: "cod_cell")
  final String? codCell;
  @JsonKey(name: "name_cell")
  final String? nameCell;
  final List<NomDTO> noms;
  @JsonKey(name: 'ErrorMassage')
  final String? errorMasssage;

  CheckCellDTO(
      {required this.codCell,
      required this.nameCell,
      required this.noms,
      required this.errorMasssage});

  factory CheckCellDTO.fromJson(Map<String, dynamic> json) =>
      _$CheckCellDTOFromJson(json);
}

@JsonSerializable()
class NomDTO {
  final String? name;
  final String? article;
  final int? qty;
  @JsonKey(name: "min_rest")
  final int? minRest;
  final List<BarcodeDTO> barcodes;

  NomDTO(
      {required this.name,
      required this.article,
      required this.qty,
      required this.minRest,
      required this.barcodes});

  factory NomDTO.fromJson(Map<String, dynamic> json) => _$NomDTOFromJson(json);
}
