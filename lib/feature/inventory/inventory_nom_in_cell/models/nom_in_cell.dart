import 'package:virok_wms/feature/inventory/inventory_nom_in_cell/models/barcode.dart';

class InventoryNomInCellTasks {
  final List<InventoryNomInCellTask> tasks;
  final String errorMassage;

  InventoryNomInCellTasks({
    required this.tasks,
    required this.errorMassage,
  });

  static final empty = InventoryNomInCellTasks(tasks: [], errorMassage: '');
}

class InventoryNomInCellTask {
  final String nom;
  final String article;
  final List<Barcode> barcodes;
  final String taskNumber;
  final String codCell;
  final String nameCell;
  final int count;
  final int scannedCount;
  final String nomStatus;

  InventoryNomInCellTask({
    required this.nom,
    required this.article,
    required this.barcodes,
    required this.taskNumber,
    required this.codCell,
    required this.nameCell,
    required this.count,
    required this.nomStatus,
    required this.scannedCount,
  });

  static final empty = InventoryNomInCellTask(
      nom: '',
      article: '',
      barcodes: [],
      taskNumber: '',
      codCell: '',
      nameCell: '',
      count: 0,
      nomStatus: '',
      scannedCount: 0);
}
