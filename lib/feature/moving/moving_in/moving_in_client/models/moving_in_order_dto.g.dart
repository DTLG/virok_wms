// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_element

part of 'moving_in_order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovingInOrdersDTO _$MovingInOrdersDTOFromJson(Map<String, dynamic> json) =>
    MovingInOrdersDTO(
      orders: (json['IncomingInvoices'] as List<dynamic>)
          .map((e) => MovingInOrderDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as int?,
    );

Map<String, dynamic> _$MovingInOrdersDTOToJson(MovingInOrdersDTO instance) =>
    <String, dynamic>{
      'IncomingInvoices': instance.orders,
      'status': instance.status,
    };

MovingInOrderDTO _$MovingInOrderDTOFromJson(Map<String, dynamic> json) =>
    MovingInOrderDTO(
      docId: json['number'] as String?,
      date: json['date'] as String?,
      customer: json['Сustomer'] as String?,
      invoice: json['invoice'] as String?,
    );

Map<String, dynamic> _$MovingInOrderDTOToJson(MovingInOrderDTO instance) =>
    <String, dynamic>{
      'number': instance.docId,
      'date': instance.date,
      'Сustomer': instance.customer,
      'invoice': instance.invoice,
    };
