import 'package:virok_wms/feature/inventory/inventory_by_cells/inventory_by_cells_client/inventory_by_cells_client.dart';
import 'package:virok_wms/feature/inventory/inventory_by_cells/models/task.dart';
import 'package:virok_wms/feature/inventory/inventory_by_cells/models/task_noms.dart';

class IventoryByCellsRepository {
  final InventoryByCellsClient _inventoryByCellsClient;

  IventoryByCellsRepository({InventoryByCellsClient? inventoryByCellsClient})
      : _inventoryByCellsClient =
            inventoryByCellsClient ?? InventoryByCellsClient();

  Future<InventoryByCellsTasks> getTasks(String query, String body) async {
    final tasks = await _inventoryByCellsClient.getTasks(query, body);

    return InventoryByCellsTasks(
        inventoryTasks: tasks.inventoryTasks
            .map((e) => InventoryByCellsTask(
                taskNumber: e.taskNumber ?? '',
                codeCell: e.codeCell ?? '',
                nameCell: e.nameCell ?? ''))
            .toList(),
        errorMassage: tasks.errorMassage ?? '');
  }

  Future<CellInventoryTaskNoms> getNoms(String query, String body) async {
    final noms = await _inventoryByCellsClient.getNoms(query, body);

    return CellInventoryTaskNoms(
        cellInventoryTaskData: noms.cellInventoryTaskData
            .map((e) => CellInventoryTaskNom(
                nom: e.nom ?? '',
                article: e.article ?? '',
                barcodes: e.barcodes
                    .map((b) => Barcode(
                        barcode: b.barcode ?? '',
                        count: b.count ?? 0,
                        ratio: b.ratio ?? 0))
                    .toList(),
                taskNumber: e.taskNumber ?? '',
                codCell: e.codCell ?? '',
                nameCell: e.nameCell ?? '',
                count: e.count ?? 0,
                scannedCount: e.scannedCount ?? 0,
                nomStatus: e.nomStatus ?? ''))
            .toList().reversed.toList(),
        errorMassage: noms.errorMassage ?? '');
  }
}
