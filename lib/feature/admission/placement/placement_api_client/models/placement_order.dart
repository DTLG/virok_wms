import 'package:json_annotation/json_annotation.dart';

part 'placement_order.g.dart';

@JsonSerializable()
class PlacementOrdersDTO {
  @JsonKey(name: 'docs')
  final List<PlacementOrderDTO> orders;
  @JsonKey(name: 'ErrorMassage')
  final String? errorMassage;

  PlacementOrdersDTO({required this.orders, required this.errorMassage});
  factory PlacementOrdersDTO.fromJson(Map<String, dynamic> json) =>
      _$PlacementOrdersDTOFromJson(json);
}

@JsonSerializable()
class PlacementOrderDTO {
  @JsonKey(name: 'incoming_invoice')
  final String? incomingInvoice;
  final String? date;

  PlacementOrderDTO({required this.incomingInvoice, required this.date});

  factory PlacementOrderDTO.fromJson(Map<String, dynamic> json) =>
      _$PlacementOrderDTOFromJson(json);
}
