// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_element

part of 'placement_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlacementOrdersDTO _$PlacementOrdersDTOFromJson(Map<String, dynamic> json) =>
    PlacementOrdersDTO(
      orders: (json['docs'] as List<dynamic>)
          .map((e) => PlacementOrderDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      errorMassage: json['ErrorMassage'] as String?,
    );

Map<String, dynamic> _$PlacementOrdersDTOToJson(PlacementOrdersDTO instance) =>
    <String, dynamic>{
      'docs': instance.orders,
      'ErrorMassage': instance.errorMassage,
    };

PlacementOrderDTO _$PlacementOrderDTOFromJson(Map<String, dynamic> json) =>
    PlacementOrderDTO(
      incomingInvoice: json['incoming_invoice'] as String?,
      date: json['date'] as String?,
    );

Map<String, dynamic> _$PlacementOrderDTOToJson(PlacementOrderDTO instance) =>
    <String, dynamic>{
      'incoming_invoice': instance.incomingInvoice,
      'date': instance.date,
    };
