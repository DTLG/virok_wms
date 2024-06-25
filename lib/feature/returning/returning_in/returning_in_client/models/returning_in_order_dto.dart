import 'package:json_annotation/json_annotation.dart';

part 'returning_in_order_dto.g.dart';

@JsonSerializable()
class ReturningInOrdersDTO {
  @JsonKey(name: 'IncomingInvoices')
  final List<ReturningInOrderDTO> orders;
  final int? status;

  ReturningInOrdersDTO({required this.orders, required this.status});
   factory ReturningInOrdersDTO.fromJson(Map<String, dynamic> json) =>
      _$ReturningInOrdersDTOFromJson(json);
}

@JsonSerializable()
class ReturningInOrderDTO {
  @JsonKey(name: 'number')
  final String? docId;
  @JsonKey(name: 'date')
  final String? date;
    @JsonKey(name: 'Сustomer')

  final String? customer;
  final String? invoice;
  // final List<BasketDTO> baskets;


  ReturningInOrderDTO({required this.docId, required this.date, required this.customer, required this.invoice});

   factory ReturningInOrderDTO.fromJson(Map<String, dynamic> json) =>
      _$ReturningInOrderDTOFromJson(json);
}

