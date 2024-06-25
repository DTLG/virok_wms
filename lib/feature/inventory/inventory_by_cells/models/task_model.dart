import 'package:json_annotation/json_annotation.dart';

part 'task_model.g.dart';

@JsonSerializable(createToJson: false)
class InventoryByCellsTasksModel {
  @JsonKey(name: 'inventory_tasks')
  final List<InventoryByCellsTaskModel> inventoryTasks;
  @JsonKey(name: 'ErrorMassage')
  final String? errorMassage;

  InventoryByCellsTasksModel(
      {required this.inventoryTasks, required this.errorMassage});

  factory InventoryByCellsTasksModel.fromJson(Map<String, dynamic> json) =>
      _$InventoryByCellsTasksModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class InventoryByCellsTaskModel {
  @JsonKey(name: 'task_number')
  final String? taskNumber;
  @JsonKey(name: 'cod_cell')
  final String? codeCell;
  @JsonKey(name: 'name_cell')
  final String? nameCell;

  InventoryByCellsTaskModel(
      {required this.taskNumber,
      required this.codeCell,
      required this.nameCell});

  factory InventoryByCellsTaskModel.fromJson(Map<String, dynamic> json) =>
      _$InventoryByCellsTaskModelFromJson(json);
}
