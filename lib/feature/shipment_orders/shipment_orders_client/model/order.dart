import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class OrdersDTO {
  @JsonKey(name: 'shipment_head')
  final List<OrderDTO> orders;

  OrdersDTO({required this.orders});
   factory OrdersDTO.fromJson(Map<String, dynamic> json) =>
      _$OrdersDTOFromJson(json);
}

@JsonSerializable()
class OrderDTO {
  @JsonKey(name: 'number')
  final String docId;
  @JsonKey(name: 'date_doc')
  final String date;
  final String client;

  OrderDTO({required this.docId, required this.date, required this.client});

   factory OrderDTO.fromJson(Map<String, dynamic> json) =>
      _$OrderDTOFromJson(json);
}
