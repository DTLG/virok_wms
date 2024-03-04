import 'package:json_annotation/json_annotation.dart';

part 'return_order_dto.g.dart';

@JsonSerializable(createPerFieldToJson: false)

class ReturnOrdersDTO {
  @JsonKey(name: 'IncomingInvoices')
  final List<ReturningInOrderDTO> orders;
  final int? status;

  ReturnOrdersDTO({required this.orders, required this.status});
   factory ReturnOrdersDTO.fromJson(Map<String, dynamic> json) =>
      _$ReturnOrdersDTOFromJson(json);
}

@JsonSerializable(createPerFieldToJson: false)
class ReturningInOrderDTO {
  @JsonKey(name: 'number')
  final String? docId;
  @JsonKey(name: 'date')
  final String? date;
    @JsonKey(name: 'Сustomer')

  final String? customer;
  final String? invoice;


  ReturningInOrderDTO({required this.docId, required this.date, required this.customer, required this.invoice});

   factory ReturningInOrderDTO.fromJson(Map<String, dynamic> json) =>
      _$ReturningInOrderDTOFromJson(json);
}

