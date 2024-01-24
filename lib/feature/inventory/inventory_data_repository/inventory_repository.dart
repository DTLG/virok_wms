import 'package:virok_wms/feature/inventory/inventory_data_client/inventory_client.dart';
import 'package:virok_wms/feature/inventory/models/doc.dart';
import 'package:virok_wms/feature/inventory/models/inventory.dart';

class InventoryRepository {
  final InventoryClient _inventoryClient;

  InventoryRepository({InventoryClient? inventoryClient})
      : _inventoryClient = inventoryClient ?? InventoryClient();

  Future<Docs> getDocs() async {
    final docs = await _inventoryClient.getDocs();
    return Docs(
        docs: docs.docs
            .map((e) =>
                Doc(docNumber: e.docNumber ?? '', docDate: e.docDate ?? ''))
            .toList(),
        errorMassage: docs.errorMassage ?? '');
  }

  Future<Inventory> getNomData(String query, String body) async {
    final doc = await _inventoryClient.getNomData(query, body);

    return Inventory(
        nom: doc.nom ?? '',
        article: doc.article ?? '',
        barcodes: (doc.barcodes ?? [])
            .map((e) => Barcode(
                barcode: e.barcode ?? '',
                count: e.count ?? 0,
                ratio: e.ratio ?? 0))
            .toList(),
        cells: (doc.cells ?? [])
            .map((e) => Cell(
                cellCode: e.cellCode ?? '',
                cellName: e.cellName ?? '',
                planCount: e.planCount ?? 0,
                factCount: e.factCount ?? 0))
            .toList(),
        docNumber: doc.docNumber ?? '',
        errorMassage: doc.errorMassage ?? '');
  }
}
