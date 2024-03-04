import 'package:json_annotation/json_annotation.dart';


part 'inventory_doc.g.dart';


@JsonSerializable(createPerFieldToJson: false)
class DocsModel {
  final List<DocModel> docs;
  @JsonKey(name: 'ErrorMassage')
  final String? errorMassage;

  DocsModel({required this.docs, required this.errorMassage});


  factory DocsModel.fromJson(Map<String, dynamic> json) =>
      _$DocsModelFromJson(json);
}


@JsonSerializable(createPerFieldToJson: false)
class DocModel {
  @JsonKey(name: 'doc_number')
  final String? docNumber;
  @JsonKey(name: 'doc_date')
  final String? docDate;

  DocModel({required this.docNumber, required this.docDate});


  factory DocModel.fromJson(Map<String, dynamic> json) =>
      _$DocModelFromJson(json);
}
