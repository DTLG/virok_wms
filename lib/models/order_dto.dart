import 'package:json_annotation/json_annotation.dart';

part 'order_dto.g.dart';

@JsonSerializable()
class OrdersDTO {
  @JsonKey(name: 'orders')
  final List<OrderDTO> orders;
  final int? status;

  OrdersDTO({required this.orders, required this.status});
  factory OrdersDTO.fromJson(Map<String, dynamic> json) =>
      _$OrdersDTOFromJson(json);
}

@JsonSerializable()
class OrderDTO {
  @JsonKey(name: 'number')
  final String? docId;
  @JsonKey(name: 'date')
  final String? date;
  final List<BasketDTO> baskets;
  @JsonKey(name: 'full_order')
  final double? fullOrdfer;
  @JsonKey(name: 'importance_mark')
  final double? importanceMark;
  @JsonKey(name: 'm_mark')
  final double? mMark;
  @JsonKey(name: 'NovaPoshta_mark')
  final double? newPostMark;

  OrderDTO(
      {required this.docId,
      required this.date,
      required this.baskets,
      required this.fullOrdfer,
      required this.importanceMark,
      required this.mMark,
      required this.newPostMark});

  factory OrderDTO.fromJson(Map<String, dynamic> json) =>
      _$OrderDTOFromJson(json);
}

@JsonSerializable()
class BasketDTO {
  final String? basket;

  BasketDTO({required this.basket});

  factory BasketDTO.fromJson(Map<String, dynamic> json) =>
      _$BasketDTOFromJson(json);
}
