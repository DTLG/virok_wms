import 'package:json_annotation/json_annotation.dart';


part 'inventory_model.g.dart';

@JsonSerializable(createPerFieldToJson: false)
class InventoryModel {
    final String? nom;
    final String? article;
    final List<Barcode>? barcodes;
    final List<Cell>? cells;
    @JsonKey(name: "doc_number")
    final String? docNumber;
    @JsonKey(name: "ErrorMassage")
    final String? errorMassage;

    InventoryModel({
        required this.nom,
        required this.article,
        required this.barcodes,
        required this.cells,
        required this.docNumber,
        required this.errorMassage,
    });


    factory InventoryModel.fromJson(Map<String, dynamic> json) => _$InventoryModelFromJson(json);

    Map<String, dynamic> toJson() => _$InventoryModelToJson(this);
}

@JsonSerializable(createPerFieldToJson: false)
class Barcode {
    final String? barcode;
    final int? count;
    final int? ratio;

    Barcode({
        required this.barcode,
        required this.count,
        required this.ratio,
    });



    factory Barcode.fromJson(Map<String, dynamic> json) => _$BarcodeFromJson(json);

    Map<String, dynamic> toJson() => _$BarcodeToJson(this);
}

@JsonSerializable()@JsonSerializable(createPerFieldToJson: false)

class Cell {
    @JsonKey(name: "сell_code")
    final String? cellCode;
    @JsonKey(name: "сell_name")
    final String? cellName;
    @JsonKey(name: "plan_count")
    final int? planCount;
    @JsonKey(name: "fact_count")
    final int? factCount;
    @JsonKey(name: 'nom_status')
    final String? nomStatus;

    Cell({
        required this.cellCode,
        required this.cellName,
        required this.planCount,
        required this.factCount,
        required this.nomStatus
    });



    factory Cell.fromJson(Map<String, dynamic> json) => _$CellFromJson(json);

    Map<String, dynamic> toJson() => _$CellToJson(this);
}
