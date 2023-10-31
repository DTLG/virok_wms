import 'package:virok_wms/feature/barcode_lable_print/barcode_lable_print_repo/models/barcodes_noms.dart';
import 'package:virok_wms/feature/placement_writing_off/placement_writeing_off_client/placement_writeing_off_api_client.dart';

import 'model/cell_model.dart';

class PlacementWritingOffRepo {
  PlacementWritingOffRepo({PlacementWritingOffClient? placementGoodsApiClient})
      : _placementGoodsApiClient =
            placementGoodsApiClient ?? PlacementWritingOffClient();

  final PlacementWritingOffClient _placementGoodsApiClient;

  Future<Cell> getCeel(String barcode) async {
    final ceel = await _placementGoodsApiClient.getCeel(barcode);
    final List<CellData> cellData = ceel.cell.map((e) {
      return CellData(
          name: e.nom ?? '',
          quantity: e.quantity ?? 0,
          nameCell: e.nameCell ?? '',
          codeCell: e.codeCell ?? '',
          article: e.article ?? '',
          barcodes: e.barcodes.map((e) => e.barcode ?? '').toList(),
          status: e.status ?? 1);
    }).toList();
    return Cell(cell: cellData, zone: ceel.zone ?? 1);
  }

  Future<Cell> sendNom(
      String query, String barcode, String count, String cell) async {
    final ceel =
        await _placementGoodsApiClient.sendNom(query, cell, barcode, count);
    final List<CellData> cellData = ceel.cell.map((e) {
      return CellData(
          name: e.nom ?? '',
          quantity: e.quantity ?? 0,
          nameCell: e.nameCell ?? '',
          codeCell: e.codeCell ?? '',
          article: e.article ?? '',
          barcodes: e.barcodes.map((e) => e.barcode ?? '').toList(),
          status: e.status ?? 1);
    }).toList();
    return Cell(cell: cellData, zone: ceel.zone ?? 1);
  }

   Future<BarcodesNoms> getNom(String query, String body) async {
    final nomsDTO = await _placementGoodsApiClient.getNom(query, body);
    List<BarcodesNom> noms = nomsDTO.noms
        .map((nom) => BarcodesNom(
            name: nom.name ?? '',
            article: nom.article ?? '',
            barodes: nom.barcodes
                .map((bar) => Barcode(
                    barcode: bar.barcode ?? '',
                    count: bar.count ?? 1,
                    ratio: bar.ratio ?? 1))
                .toList()))
        .toList();
    return BarcodesNoms(noms: noms);
  }
}



