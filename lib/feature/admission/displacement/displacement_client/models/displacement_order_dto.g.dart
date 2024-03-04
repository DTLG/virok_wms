// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_element

part of 'displacement_order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DisplacementOrdersDTO _$DisplacementOrdersDTOFromJson(
        Map<String, dynamic> json) =>
    DisplacementOrdersDTO(
      orders: (json['IncomingInvoices'] as List<dynamic>)
          .map((e) => DisplacementOrderDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as int?,
    );

Map<String, dynamic> _$DisplacementOrdersDTOToJson(
        DisplacementOrdersDTO instance) =>
    <String, dynamic>{
      'IncomingInvoices': instance.orders,
      'status': instance.status,
    };

DisplacementOrderDTO _$DisplacementOrderDTOFromJson(
        Map<String, dynamic> json) =>
    DisplacementOrderDTO(
      docId: json['number'] as String?,
      date: json['date'] as String?,
      customer: json['Сustomer'] as String?,
      invoice: json['invoice'] as String?,
    );

Map<String, dynamic> _$DisplacementOrderDTOToJson(
        DisplacementOrderDTO instance) =>
    <String, dynamic>{
      'number': instance.docId,
      'date': instance.date,
      'Сustomer': instance.customer,
      'invoice': instance.invoice,
    };
