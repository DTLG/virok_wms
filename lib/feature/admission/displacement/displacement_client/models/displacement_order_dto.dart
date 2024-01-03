import 'package:json_annotation/json_annotation.dart';

part 'displacement_order_dto.g.dart';

@JsonSerializable()
class DisplacementOrdersDTO {
  @JsonKey(name: 'IncomingInvoices')
  final List<DisplacementOrderDTO> orders;
  final int? status;

  DisplacementOrdersDTO({required this.orders, required this.status});
   factory DisplacementOrdersDTO.fromJson(Map<String, dynamic> json) =>
      _$DisplacementOrdersDTOFromJson(json);
}

@JsonSerializable()
class DisplacementOrderDTO {
  @JsonKey(name: 'number')
  final String? docId;
  @JsonKey(name: 'date')
  final String? date;
    @JsonKey(name: 'Сustomer')

  final String? customer;
  final String? invoice;
  // final List<BasketDTO> baskets;


  DisplacementOrderDTO({required this.docId, required this.date, required this.customer, required this.invoice});

   factory DisplacementOrderDTO.fromJson(Map<String, dynamic> json) =>
      _$DisplacementOrderDTOFromJson(json);
}

