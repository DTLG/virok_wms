import 'package:virok_wms/feature/inventory/inventory_by_nom/inventory_by_nom_client/inventory_by_nom_client.dart';
import 'package:virok_wms/feature/inventory/inventory_by_nom/models/barcode.dart';
import 'package:virok_wms/feature/inventory/inventory_by_nom/models/cells_by_nom.dart';
import 'package:virok_wms/feature/inventory/inventory_by_nom/models/task.dart';

class IventoryByNomRepository {
  final InventoryByNomClient _inventoryByNomClient;

  IventoryByNomRepository({InventoryByNomClient? inventoryByNomClient})
      : _inventoryByNomClient = inventoryByNomClient ?? InventoryByNomClient();

  Future<InventoryByNomTasks> getTasks(String query, String body) async {
    final tasks = await _inventoryByNomClient.getTasks(query, body);

    return InventoryByNomTasks(
        tasks: tasks.inventoryTasks
            .map((e) => InventoryByNomTask(
                docNumber: e.docNumber ?? '',
                date: e.date ?? '',
                nom: e.nom ?? '',
                article: e.article ?? '',
                barcodes: e.barcodes
                    .map((b) => Barcode(
                        barcode: b.barcode ?? '',
                        count: b.count ?? 0,
                        ratio: b.ratio ?? 0))
                    .toList()))
            .toList(),
        errorMassage: tasks.errorMassage ?? '');
  }

  Future<CellsByNom> getCells(String query, String body) async {
    final nom = await _inventoryByNomClient.getCells(query, body);

    return CellsByNom(
        nom: nom.nom ?? '',
        article: nom.article ?? '',
        barcodes: (nom.barcodes ?? [])
            .map((e) => Barcode(
                barcode: e.barcode ?? '', count: e.count ?? 0, ratio: e.ratio ?? 0))
            .toList(),
        cells: (nom.cells ?? [])
            .map((e) => Cell(
                code: e.code ?? '',
                name: e.name ?? '',
                planCount: e.planCount ?? 0,
                factCount: e.factCount ?? 0,
                nomStatus: e.nomStatus ?? ''))
            .toList(),
        docNumber: nom.docNumber ?? '',
        errorMassage: nom.errorMassage ?? '');
  }
}
