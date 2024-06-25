import 'package:virok_wms/feature/inventory/inventory_nom_in_cell/inventory_nom_in_cell_client/inventory_nom_in_cell_client.dart';
import 'package:virok_wms/feature/inventory/inventory_nom_in_cell/models/barcode.dart';
import 'package:virok_wms/feature/inventory/inventory_nom_in_cell/models/nom_in_cell.dart';

class InventoryNomInCellRepository {
  final InventoryNomIncellClient _inventoryNomIncellClient;
  InventoryNomInCellRepository(
      {InventoryNomIncellClient? inventoryNomIncellClient})
      : _inventoryNomIncellClient =
            inventoryNomIncellClient ?? InventoryNomIncellClient();

  Future<InventoryNomInCellTasks> getTasks(String query, String body) async {
    final tasks = await _inventoryNomIncellClient.getTasks(query, body);

    return InventoryNomInCellTasks(
        tasks: (tasks.tasks ?? [])
            .map((e) => InventoryNomInCellTask(
                nom: e.nom ?? '',
                article: e.article ?? '',
                nomStatus: e.nomSatus ?? '',
                barcodes: (e.barcodes ?? [])
                    .map((e) => Barcode(
                        barcode: e.barcode ?? '',
                        count: e.count ?? 0,
                        ratio: e.ratio ?? 0))
                    .toList(),
                taskNumber: e.taskNumber ?? '',
                codCell: e.codCell ?? '',
                nameCell: e.nameCell ?? '',
                count: e.count ?? 0,
                scannedCount: e.scannedCount ?? 0))
            .toList(),
        errorMassage: tasks.errorMassage ?? '');
  }
}
