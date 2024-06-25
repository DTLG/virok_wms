// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_element

part of 'returning_in_order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReturningInOrdersDTO _$ReturningInOrdersDTOFromJson(
        Map<String, dynamic> json) =>
    ReturningInOrdersDTO(
      orders: (json['IncomingInvoices'] as List<dynamic>)
          .map((e) => ReturningInOrderDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as int?,
    );

Map<String, dynamic> _$ReturningInOrdersDTOToJson(
        ReturningInOrdersDTO instance) =>
    <String, dynamic>{
      'IncomingInvoices': instance.orders,
      'status': instance.status,
    };

ReturningInOrderDTO _$ReturningInOrderDTOFromJson(Map<String, dynamic> json) =>
    ReturningInOrderDTO(
      docId: json['number'] as String?,
      date: json['date'] as String?,
      customer: json['Сustomer'] as String?,
      invoice: json['invoice'] as String?,
    );

Map<String, dynamic> _$ReturningInOrderDTOToJson(
        ReturningInOrderDTO instance) =>
    <String, dynamic>{
      'number': instance.docId,
      'date': instance.date,
      'Сustomer': instance.customer,
      'invoice': instance.invoice,
    };
