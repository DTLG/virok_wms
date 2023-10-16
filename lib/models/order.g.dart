// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrdersDTO _$OrdersDTOFromJson(Map<String, dynamic> json) => OrdersDTO(
      orders: (json['orders'] as List<dynamic>)
          .map((e) => OrderDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrdersDTOToJson(OrdersDTO instance) => <String, dynamic>{
      'orders': instance.orders,
    };

OrderDTO _$OrderDTOFromJson(Map<String, dynamic> json) => OrderDTO(
      docId: json['number'] as String?,
      date: json['date'] as String?,
      client: json['client'] as String?,
    );

Map<String, dynamic> _$OrderDTOToJson(OrderDTO instance) => <String, dynamic>{
      'number': instance.docId,
      'date': instance.date,
      'client': instance.client,
    };
