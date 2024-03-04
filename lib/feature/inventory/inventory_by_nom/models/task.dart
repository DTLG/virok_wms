import 'package:virok_wms/feature/inventory/inventory_by_nom/models/barcode.dart';

class InventoryByNomTasks {
  final List<InventoryByNomTask> tasks;
  final String errorMassage;

  InventoryByNomTasks(
      {required this.tasks, required this.errorMassage});

  static final empty =
      InventoryByNomTasks(tasks: [], errorMassage: '');
}

class InventoryByNomTask {
  final String docNumber;
  final String date;
  final String nom;
  final String article;
    final List<Barcode> barcodes;


  InventoryByNomTask(
      {required this.docNumber,
      required this.date,
      required this.nom,
      required this.article,
      required this.barcodes
      });

  static final empty =
      InventoryByNomTask(docNumber: '', date: '', nom: '', article: '', barcodes: []);
}

