import 'package:json_annotation/json_annotation.dart';

part 'basket_info.g.dart';

@JsonSerializable()
class BasketDataDTO {
  @JsonKey(name: 'doc_number')
  String? docNumber;
  TableDTO table;
  String? basket;

  BasketDataDTO({required this.docNumber,required this.table,required this.basket});

  
   factory BasketDataDTO.fromJson(Map<String, dynamic> json) => _$BasketDataDTOFromJson(json);
}
@JsonSerializable()
class TableDTO {
  String? name;
  String? barcode;

  TableDTO({required this.name,required this.barcode});
  factory TableDTO.fromJson(Map<String, dynamic> json) => _$TableDTOFromJson(json);
 
}



