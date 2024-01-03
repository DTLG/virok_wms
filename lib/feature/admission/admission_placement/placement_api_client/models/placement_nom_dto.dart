import 'package:json_annotation/json_annotation.dart';
import 'package:virok_wms/models/barcode_dto_model.dart';

part 'placement_nom_dto.g.dart';

@JsonSerializable()
class PlacementNomsDTO {
  final List<PlacementNomDTO> noms;
  @JsonKey(name:'ErrorMassage')
  final String? errorMassage;

  PlacementNomsDTO({
    required this.noms,
    required this.errorMassage
  });

  factory PlacementNomsDTO.fromJson(Map<String, dynamic> json) =>
      _$PlacementNomsDTOFromJson(json);

}

@JsonSerializable()
class PlacementNomDTO {
  @JsonKey(name: "mom")
  final String? name;
  final String? article;
  final List<BarcodeDTO> barcodes;
  @JsonKey(name: "all_count")
  final double? allCount;
  @JsonKey(name: "free_count")
  final double? freeCount;
  @JsonKey(name: "reserved_count")
  final double? reservedCount;

  factory PlacementNomDTO.fromJson(Map<String, dynamic> json) =>
      _$PlacementNomDTOFromJson(json);

  PlacementNomDTO(
      {required this.name,
      required this.article,
      required this.barcodes,
      required this.allCount,
      required this.freeCount,
      required this.reservedCount});

}
