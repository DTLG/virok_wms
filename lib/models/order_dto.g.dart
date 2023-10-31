// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrdersDTO _$OrdersDTOFromJson(Map<String, dynamic> json) => OrdersDTO(
      orders: (json['orders'] as List<dynamic>)
          .map((e) => OrderDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as int?,
    );

Map<String, dynamic> _$OrdersDTOToJson(OrdersDTO instance) => <String, dynamic>{
      'orders': instance.orders,
      'status': instance.status,
    };

OrderDTO _$OrderDTOFromJson(Map<String, dynamic> json) => OrderDTO(
      docId: json['number'] as String?,
      date: json['date'] as String?,
      baskets: (json['baskets'] as List<dynamic>)
          .map((e) => BasketDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderDTOToJson(OrderDTO instance) => <String, dynamic>{
      'number': instance.docId,
      'date': instance.date,
      'baskets': instance.baskets,
    };

BasketDTO _$BasketDTOFromJson(Map<String, dynamic> json) => BasketDTO(
      basket: json['basket'] as String?,
    );

Map<String, dynamic> _$BasketDTOToJson(BasketDTO instance) => <String, dynamic>{
      'basket': instance.basket,
    };
