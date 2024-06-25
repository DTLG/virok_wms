import 'package:json_annotation/json_annotation.dart';

part 'moving_in_order_dto.g.dart';

@JsonSerializable()
class MovingInOrdersDTO {
  @JsonKey(name: 'IncomingInvoices')
  final List<MovingInOrderDTO> orders;
  final int? status;

  MovingInOrdersDTO({required this.orders, required this.status});
   factory MovingInOrdersDTO.fromJson(Map<String, dynamic> json) =>
      _$MovingInOrdersDTOFromJson(json);
}

@JsonSerializable()
class MovingInOrderDTO {
  @JsonKey(name: 'number')
  final String? docId;
  @JsonKey(name: 'date')
  final String? date;
    @JsonKey(name: 'Сustomer')

  final String? customer;
  final String? invoice;
  // final List<BasketDTO> baskets;


  MovingInOrderDTO({required this.docId, required this.date, required this.customer, required this.invoice});

   factory MovingInOrderDTO.fromJson(Map<String, dynamic> json) =>
      _$MovingInOrderDTOFromJson(json);
}

